class ReferencesController < ApplicationController
  include ReferencesHelper

  before_action :logged_in_user, only: [:new, :create, :destroy]

  def from_timeline
    @best_comment = BestComment.find_by_reference_id(params[:reference_id])
    @ref = Reference.select(:id, :category, :author).find(params[:reference_id])
    @target = Reference.select(:id, :year, :title, :title_fr)
                  .joins('INNER JOIN "reference_edges" ON "reference_edges"."target" = "references"."id"')
                  .where(reference_edges: {reference_id: params[:reference_id]})
    @from = Reference.select(:id, :year, :title, :title_fr)
                .joins(:reference_edges)
                .where(reference_edges: {target: params[:reference_id]})
    respond_to do |format|
      format.html { render partial: 'references/best_comment',
                           locals: {best_comment: @best_comment} }
      format.js
    end
  end

  def previous
    refs = Reference.select(:id, :slug, :year).order(year: :desc).where(timeline_id: params[:timeline_id])
    i = refs.index { |x| x.id == params[:id].to_i }
    i ||= rand(refs.length)
    if i.present?
      if i == 0
        i = refs.length - 1
      else
        i -= 1
      end
      redirect_to reference_path(refs[i])
    else
      flash[:danger] = t('controllers.timeline_record_not_found')
      redirect_to timelines_path
    end
  end

  def next
    refs = Reference.select(:id, :slug, :year).order(year: :desc).where(timeline_id: params[:timeline_id])
    i = refs.index { |x| x.id == params[:id].to_i }
    i ||= rand(refs.length)
    if i.present?
      if i == refs.length-1
        i = 0
      else
        i += 1
      end
      redirect_to reference_path(refs[i])
    else
      flash[:danger] = t('controllers.timeline_record_not_found')
      redirect_to timelines_path
    end
  end

  def from_reference
    if logged_in?
      @my_votes = Vote.where(user_id: current_user.id, reference_id: params[:reference_id], field: params[:field])
    end
    Comment.connection.execute("select setseed(#{rand})")
    params[:timeline_id] = Reference.select(:timeline_id).find(params[:reference_id]).timeline_id
    case params[:field].to_i
      when 6
        @best_fields = Comment.select(:created_at, :id, :title_markdown, :user_id, :f_6_balance)
                           .joins(:comment_joins).where(comment_joins: {reference_id: params[:reference_id], field: 6})
                           .order('random()')
      when 7
        @best_fields = Comment.select(:created_at, :id, :caption_markdown, :user_id, :figure_id, :f_7_balance)
                           .joins(:comment_joins).where(comment_joins: {reference_id: params[:reference_id], field: 7})
                           .order('random()')
      else
        @best_fields = Comment.select(:created_at, :id, "markdown_#{params[:field]}", :user_id, "f_#{params[:field]}_balance")
                           .joins(:comment_joins).where(comment_joins: {reference_id: params[:reference_id], field: params[:field].to_i})
                           .order('random()')
    end
    respond_to do |format|
      format.html { render partial: 'best_comments/best_fields',
                           locals: {best_fields: @best_fields, field: params[:field].to_i,
                                    reference_id: params[:reference_id].to_i} }
      format.js
    end
  end

  def new
    @reference = Reference.new
    @reference.open_access = false
    @reference.category = 0
    @reference.timeline_id = params[:timeline_id]
    @reference.user_binary = "none"
    @reference.user_rating = "none"
    @tag_list = []
  end

  def create
    @reference = Reference.new(reference_params)
    @reference.user_id = current_user.id
    @reference.title_fr = ""
    if params[:title] || params[:doi]
      if params[:title]
        query = params[:reference][:title]
      else
        query = params[:reference][:doi]
      end
      unless query.blank?
        begin
          @reference = fetch_reference(query)
          @reference.category = reference_params[:category]
          @reference.open_access = reference_params[:open_access]
          @reference.timeline_id = reference_params[:timeline_id]
        rescue ArgumentError
          flash.now[:danger] = t('controllers.ref_argument_error')
        rescue ConnectionError
          flash.now[:danger] = t('controllers.ref_connexion_error')
        rescue StandardError
          flash.now[:danger] = t('controllers.ref_standard_error')
        end
      end
      @tag_list = params[:reference][:tag_list].blank? ? [] : params[:reference][:tag_list]
      params[:timeline_id] = reference_params[:timeline_id]
      render 'new'
    else
      same = @reference.same_doi
      if same
        flash[:danger] = t('controllers.ref_same_doi')
        redirect_to same
      else
        if @reference.save
          Binary.create({user_id: current_user.id,
                         timeline_id: @reference.timeline_id,
                         reference_id: @reference.id, value: @reference.user_binary})
          Rating.create({user_id: current_user.id,
                         timeline_id: @reference.timeline_id,
                         reference_id: @reference.id, value: @reference.user_rating})
          ref_user_tag = ReferenceUserTag.find_or_create_by(reference_id: @reference.id,
                                                            user_id: current_user.id,
                                                            timeline_id: @reference.timeline_id)
          if ref_user_tag.set_tag_list(params[:reference][:tag_list].blank? ? [] : params[:reference][:tag_list])
            flash[:success] = t('controllers.ref_added')
          else
            flash[:success] = t('controllers.ref_added_no_tags')
          end
          redirect_to new_comment_path(reference_id: @reference.id)
        else
          @tag_list = params[:reference][:tag_list].blank? ? [] : params[:reference][:tag_list]
          params[:timeline_id] = reference_params[:timeline_id]
          render 'new'
        end
      end
    end
  end

  def edit
    @reference = Reference.find(params[:id])
  end

  def update
    @reference = Reference.find(params[:id])
    if @reference.user_id == current_user.id || current_user.admin
      if @reference.update(reference_params)
        flash[:success] = t('controllers.ref_updated')
        redirect_to @reference
      else
        render 'edit'
      end
    else
      redirect_to @reference
    end
  end

  def show
    begin
      @reference = Reference.find(params[:id])
      Reference.increment_counter(:views, @reference.id)
      @target = Reference.select(:id, :year, :title, :title_fr)
                    .joins('INNER JOIN "reference_edges" ON "reference_edges"."target" = "references"."id"')
                    .where(reference_edges: {reference_id: @reference.id})
      @from = Reference.select(:id, :year, :title, :title_fr)
                  .joins(:reference_edges)
                  .where(reference_edges: {target: @reference.id})
      @timeline = Timeline.select(:id, :slug, :private).find(@reference.timeline_id)
      if @timeline.private && !logged_in?
        flash[:danger] = "Cette référence appartient à une controverse privée, vous ne pouvez pas y accèder !"
        redirect_to_back timelines_path
      else
        if logged_in?
          user_id = current_user.id
          @reference.update_visite_by_user(user_id)
          ref_user_tag = ReferenceUserTag.find_by(user_id: user_id,
                                                  reference_id: @reference.id)
          if ref_user_tag
            @tag_list = ref_user_tag.get_tag_list
          else
            @tag_list = []
          end
          @user_rating = @reference.ratings.find_by(user_id: user_id)
          unless @user_rating.nil?
            @user_rating = @user_rating.value
          end
          if @reference.binary != ''
            @user_binary = @reference.binaries.find_by(user_id: user_id,
                                                       frame_id: Frame.select(:id).find_by(timeline_id: @reference.timeline_id, best: true).id)
            unless @user_binary.nil?
              @user_binary = @user_binary.value
            end
          end
          visit = VisiteReference.find_by(user_id: user_id, reference_id: @reference.id)
          if visit
            visit.update(updated_at: Time.zone.now)
          else
            VisiteReference.create(user_id: user_id, reference_id: @reference.id)
          end
          @my_votes = Vote.where(user_id: current_user.id, reference_id: @reference.id)
          @comment = Comment.find_by(user_id: user_id, reference_id: @reference.id)
          if params[:filter] == "my-vote"
            @best_comment = BestComment.new
            @my_votes.each do |vote|
              @best_comment["f_#{vote.field}_comment_id"] = vote.comment_id
              @best_comment["f_#{vote.field}_user_id"] = vote.comment_short.user_id
            end
          else
            @best_comment = BestComment.find_by_reference_id(@reference.id)
          end
        else
          @best_comment = BestComment.find_by_reference_id(@reference.id)
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t('controllers.ref_record_not_found')
      redirect_to timelines_path
    end
  end

  def destroy
    reference = Reference.find(params[:id])
    if reference.user_id == current_user.id || current_user.admin
      reference.destroy_with_counters
      redirect_to timeline_path(reference.timeline_id)
    end
  end

  def graph
  end

  def network
    @nodes = Reference.select(:id, :slug, :title, :title_fr, :binary_most, :star_most)
                 .where(timeline_id: params[:timeline_id])
    @links = ReferenceEdge.select(:id, :timeline_id, :reference_id, :target, :balance)
                 .where(timeline_id: params[:timeline_id])
                 .to_a.reject { |i| i.balance < 0 }.uniq { |e| [e.timeline_id, e.target].sort }
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :timeline_id, :user_binary, :user_rating,
                                      :open_access, :url, :author, :year, :doi, :journal, :abstract, :category)
  end

end
