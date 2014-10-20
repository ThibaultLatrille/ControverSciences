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
    session[:timeline_id] = @reference.timeline_id
    @comment = Comment.new()
    @comments_f1 = @reference.comments.order(rank: :desc).where(field: 1).first(5)
    @comment_f1_user = @reference.comments.where(field: 1, user: current_user.id).first
    @comments_f2 = @reference.comments.order(rank: :desc).where(field: 2).first(5)
    @comment_f2_user = @reference.comments.where(field: 2, user: current_user.id).first
    @comments_f3 = @reference.comments.order(rank: :desc).where(field: 3).first(5)
    @comment_f3_user = @reference.comments.where(field: 3, user: current_user.id).first
    @comments_f4 = @reference.comments.order(rank: :desc).where(field: 4).first(5)
    @comment_f4_user = @reference.comments.where(field: 4, user: current_user.id).first
    @comments_f5 = @reference.comments.order(rank: :desc).where(field: 5).first(5)
    @comment_f5_user = @reference.comments.where(field: 5, user: current_user.id).first
    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :title_en, :authors, :year, :doi, :journal, :abstract)
  end

end
