class ReferencesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def new
    session[:reference_params] ||= {user_id: current_user.id, timeline_id: session[:timeline_id]}
    @reference = Reference.new(session[:reference_params])
    @reference.current_step = session[:reference_step]
  end

  def create
    session[:reference_params].deep_merge!(params[:reference]) if params[:reference]
    @reference = Reference.new(session[:reference_params])
    @reference.current_step = session[:reference_step]
    if params[:back_button]
      @reference.previous_step
    elsif @reference.valid?
      if @reference.first_step?
        if not @reference.title_en.empty?
          fetch_from_crossref
        end
        @reference.next_step
      elsif @reference.last_step?
        #if not one reference with the same DOI
        @reference.save if @reference.all_valid?
      else
        @reference.next_step
      end
    end
    session[:reference_step] = @reference.current_step
    if @reference.new_record?
      render 'new'
    else
      session[:reference_step] = session[:reference_params] = nil
      flash[:success] = "Référence créer"
      redirect_to @reference
    end
  end

  def show
    @reference = Reference.find(params[:id])
    session[:reference_id] = params[:id]
    session[:reference_title] = @reference.title
    session[:timeline_id] = @reference.timeline_id
    session[:timeline_name] = @reference.timeline.name
    session[:fields_user] = []
    @comment = Comment.new()
    @comments = Hash.new()
    @comments_user = Hash.new()
    for fi in 1..5
      @comments[fi] = @reference.comments.order(rank: :desc).where(field: fi).first(5)
      @comments_user[fi] = @reference.comments.where(field: fi, user: current_user.id).first
      session[:fields_user].push(fi) if @comments_user[fi]
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :title_en, :authors, :year, :doi, :journal, :abstract)
  end

end
