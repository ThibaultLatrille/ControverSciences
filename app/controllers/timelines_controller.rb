class TimelinesController < ApplicationController
  before_action :logged_in_user, only: [:new, :edit, :update, :create, :destroy, :invited, :mine]

  def invited
    @private_timelines = PrivateTimeline.includes(:timeline).where(user_id: current_user.id)
  end

  def mine
    @mine_timelines = Timeline.where(user_id: current_user.id, private: true)
  end

  def index
    if params[:sort] == "nb_edits"
      params[:sort] = :nb_comments
    end
    params[:order] = (params[:order].present? && (params[:order] == 'asc' || params[:order] == 'desc')) ? params[:order] : "desc"
    query = Timeline.includes(:tags).order(params[:sort].blank? ? :score : params[:sort].to_sym => params[:order],
                                           created_at: params[:order])
                .where.not(private: true)
    unless params[:filter].blank?
      query = query.search_by_name(params[:filter])
      unless params[:tag].blank?
        params[:tag] = params[:tag].split
      end
    end
    unless params[:tag].blank? || params[:tag] == 'all' || params[:tag] == [''] || params[:tag] == ["all"]
      query = query.joins(taggings: :tag)
                  .where(tags: {name: params[:tag]})
    end
    if logged_in?
      unless params[:interest].blank?
        query = query.joins(:likes)
                    .where(likes: {user_id: current_user.id})
      end
      @my_likes = Like.where(user_id: current_user.id).pluck(:timeline_id)
    end

    @staging_count = query.where(staging: true).count
    @built_count = query.where(staging: false).count

    if logged_in? && params[:staging] == "true"
      query = query.where(staging: true)
    elsif (logged_in? && params[:staging] == "false") || !logged_in?
      query = query.where(staging: false)
    end
    @timelines = query.page(params[:page]).per(24)
    params[:tag] = [params[:tag]].flatten
  end

  def new
    @timeline = Timeline.new
    @timeline.binary = true
    @tag_list = []
    if current_user.private_timeline
      @timeline.private = true
    end
  end

  def edit
    @frame = Frame.find_by(timeline_id: params[:id], user_id: current_user.id)
    redirect_to edit_frame_path(@frame.id)
  end

  def create
    @timeline = Timeline.new(user_id: current_user.id, frame: timeline_params[:frame],
                             name: timeline_params[:name], staging: true,
                             private: (current_user.private_timeline ? timeline_params[:private] : false))
    if timeline_params[:binary] == "1"
      @timeline.binary = "#{timeline_params[:binary_left].strip}&&#{timeline_params[:binary_right].strip}"
    else
      @timeline.binary = ''
    end
    if @timeline.binary.downcase == "non&&oui"
      @timeline.binary = "Oui&&Non"
    end
    if @timeline.content_valid? && @timeline.save
      flash[:success] = t('controllers.timeline_added')
      redirect_to @timeline
    else
      @tag_list = @timeline.get_tag_list
      if @timeline.binary != ''
        @timeline.binary_left = @timeline.binary.split('&&')[0]
        @timeline.binary_right = @timeline.binary.split('&&')[1]
        @timeline.binary = true
      else
        @timeline.binary = false
      end
      render 'new'
    end
  end

  def show
    begin
      @timeline = Timeline.find(params[:id])
      if @timeline.private && !logged_in?
        flash[:danger] = "Cette controverse est privée, vous ne pouvez pas y accèder !"
        redirect_to_back timelines_path
      else
        Timeline.increment_counter(:views, @timeline.id)
        summary_best = SummaryBest.find_by(timeline_id: @timeline.id)
        if summary_best
          @summary = Summary.find(summary_best.summary_id)
        else
          @summary = nil
        end
        timeline_ids = Edge.select(:target, :timeline_id)
                           .where("timeline_id = ? OR target = ?",
                                  @timeline.id,
                                  @timeline.id).map { |e| [e.target, e.timeline_id] }.flatten.uniq
        if timeline_ids.length > 2
          @timelines = Timeline.select(:slug, :id, :name)
                           .where(id: timeline_ids)
                           .where.not(private: true)
                           .where.not(id: @timeline.id).limit(7).order("RANDOM()")
        else
          @timelines = []
        end
        if logged_in?
          @timeline.update_visite_by_user(current_user.id)
          @improve = Summary.where(user_id: current_user.id, timeline_id: @timeline.id).count == 1 ? false : true
          @my_frame = Frame.where(user_id: current_user.id, timeline_id: @timeline.id).count == 1 ? true : false
          @my_like = Like.where(user_id: current_user.id, timeline_id: @timeline.id).count == 1 ? true : false
        end
        @improve_frame = Frame.find_by(best: true, timeline_id: @timeline.id)
        @titles = Reference.where(timeline_id: @timeline.id, title_fr: '').count
        ref_query = Reference.order(year: :desc).where(timeline_id: @timeline.id)
                        .select(:category, :id, :slug, :title_fr, :title, :year, :binary_most, :star_most, :nb_edits)
        unless logged_in?
          ref_query = ref_query.where.not(title_fr: '')
        end
        @references = ref_query
      end
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t('controllers.timeline_record_not_found')
      redirect_to timelines_path
    end
  end

  def destroy
    timeline = Timeline.find(params[:id])
    if (timeline.user_id == current_user.id && !current_user.private_timeline) || current_user.admin
      timeline.destroy
      redirect_to timelines_path
    end
  end

  def update
    timeline = Timeline.find(params[:id])
    if current_user.admin
      unless timeline_params[:source].blank?
        if timeline_params[:delete_picture] == 'true'
          timeline.figure_id = nil
        elsif timeline_params[:has_picture] == 'true'
          timeline.figure_id = Figure.order(:created_at).where(user_id: current_user.id,
                                                               img_timeline_id: timeline.id).last.id
        end
        if timeline.save
          Figure.where(id: timeline.figure_id).update_all(source: timeline_params[:source])
          render 'timelines/success'
        end
      end
    end
  end

  def graph
  end

  def network
    @nodes = Timeline.select(:id, :slug, :name, :staging, :score).where.not(private: true)
    @links = Edge.select(:id, :timeline_id, :target, :balance)
                 .where(target: @nodes.map { |t| t.id })
                 .where(timeline_id: @nodes.map { |t| t.id }).to_a
                 .reject { |i| i.balance < 0 }
                 .uniq { |e| [e.timeline_id, e.target].sort }
  end

  def set_public
    if current_user.admin
      Timeline.find(params[:timeline_id]).create_notifications
      Timeline.where(id: params[:timeline_id]).update_all(private: false)
    else
      flash[:danger] = t('controllers.only_admins')
    end
    redirect_to_back timelines_path
  end

  def switch_staging
    if current_user.admin
      staging = Timeline.select(:staging).find(params[:timeline_id]).staging
      Timeline.where(id: params[:timeline_id]).update_all(staging: !staging)
      if staging && Rails.env.production?
        @eclosion_timeline = Timeline.find(params[:timeline_id])
        mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
        TimelineContributor.includes(:user).where(timeline_id: params[:timeline_id]).each do |timelinecontributor|
          @eclosion_user = timelinecontributor.user
          message = {
              :subject => t('controllers.eclosion_email'),
              :from => "ControverSciences.org <contact@controversciences.org>",
              :to => @eclosion_user.email,
              :html => render_to_string(:file => 'user_mailer/eclosion', layout: nil).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
      end
    else
      flash[:danger] = t('controllers.only_admins')
    end
    redirect_to_back timelines_path
  end

  def switch_favorite
    if current_user.admin
      favorite_timeline = Timeline.select(:favorite, :staging).find(params[:timeline_id])
      Timeline.where(favorite: true, staging: favorite_timeline.staging).update_all(favorite: false)
      Timeline.where(id: params[:timeline_id]).update_all(favorite: !favorite_timeline.favorite)
    else
      flash[:danger] = t('controllers.only_admins')
    end
    redirect_to_back timelines_path
  end

  def next
    timelines = Timeline.select(:id, :slug, :score).order(score: :desc).where.not(private: true)
    unless logged_in?
      timelines.where(staging: false)
    end
    i = timelines.index { |x| x.id == params[:id].to_i }
    i ||= rand(timelines.length)
    if i == timelines.length - 1
      i = 0
    else
      i += 1
    end
    redirect_to timeline_path(timelines[i])
  end

  def download_bibtex
    references= Reference.where(timeline_id: params[:timeline_id])
    if params[:format] == "json"
      data = generate_bibtex(references).to_json
    elsif params[:format] == "yaml"
      data = generate_bibtex(references).to_yaml
    elsif params[:format] == "xml"
      data = generate_bibtex(references).to_xml
    else
      params[:format] = "bib"
      data = generate_bibtex(references).to_s
    end
    send_data data,
              filename: "#{Timeline.select(:slug).find(params[:timeline_id]).slug}.#{params[:format]}",
              type: "application/bib"
  end

  def feed
    @timeline_feed = Timeline.includes(:user).order('created_at DESC').where.not(private: true).where(staging: false).first(200)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  private

  def generate_bibtex(references)
    bib = BibTeX::Bibliography.new
    references.each do |reference|
      bib << BibTeX::Entry.new({:bibtex_type => :article,
                                :author => reference.author,
                                :doi => reference.doi,
                                :journal => reference.journal,
                                :title => reference.title,
                                :publisher => reference.publisher,
                                :url => reference.url,
                                :year => reference.year,
                                :abstract => reference.abstract
                               })
    end
    bib
  end

  def timeline_params
    params.require(:timeline).permit(:name, :binary, :frame, :binary_left,
                                     :binary_right, :img_timeline_id,
                                     :delete_picture, :has_picture, :source, :private)
  end
end
