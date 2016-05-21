class StaticPagesController < ApplicationController
  def home
    random_choices_and_favorite
  end

  def new_home
    random_choices_and_favorite
  end

  def markdown_tutorial
    @timeline = Timeline.order(score: :desc).first
    @list = Reference.order(year: :desc).where(timeline_id: @timeline.id).pluck(:title, :id, :author)
    @tim_list = timelines_connected_to(@timeline.id)
  end

  def empty_comments
    query = Reference.includes(:timeline).includes(:reference_user_tags).order(:created_at => :desc)
                    .where(title_fr: '')
    if logged_in?
      @like_ids = Like.where(user_id: current_user.id).pluck(:timeline_id)
      if params[:filter] == "mine"
        query = query.where(user_id: current_user.id)
      elsif params[:filter] == "interest"
        query = query.where( timeline_id: @like_ids )
      end
    end
    @empty_comments = query.page(params[:page]).per(12)
  end

  def empty_summaries
    query = Timeline.order(:created_at => :desc)
                    .where(nb_summaries: 0)
                    .where.not(nb_references: 0..3)
                    .where.not(nb_comments: 0..3)
    if logged_in?
      @like_ids = Like.where(user_id: current_user.id).pluck(:timeline_id)
      if params[:filter] == "mine"
        query = query.where(user_id: current_user.id)
      elsif params[:filter] == "interest"
        query = query.where( id: @like_ids )
      end
    end
    @empty_summaries = query.page(params[:page]).per(12)
  end

  def empty_references
    query = Timeline.order(:created_at => :desc)
                    .where(nb_references: 0..3)
    if logged_in?
      @like_ids = Like.where(user_id: current_user.id).pluck(:timeline_id)
      if params[:filter] == "mine"
        query = query.where(user_id: current_user.id)
      elsif params[:filter] == "interest"
        query = query.where( id: @like_ids )
      end
    end
    @empty_references = query.page(params[:page]).per(12)
  end

  def newsletter
  end

  def faq
    @questions = Question.all
  end
end
