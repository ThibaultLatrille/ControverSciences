class StaticPagesController < ApplicationController
  def home
    @timelines = Timeline.order(:score => :desc).first(8)
    if logged_in?
      @my_likes = Like.where(user_id: current_user.id).pluck(:timeline_id)
    end
  end

  def empty_comments
    query = Reference.select(:id, :title, :timeline_id, :created_at)
                    .order(:created_at => :desc)
                    .where(title_fr: nil)
    if logged_in?
      @like_ids = Like.where(user_id: current_user.id).pluck(:timeline_id)
      if params[:filter] == "mine"
        query = query.where(user_id: current_user.id)
      elsif params[:filter] == "interest"
        query = query.where( timeline_id: @like_ids )
      end
    end
    @references = query
  end

  def empty_summaries
    query = Timeline.select(:id, :name, :created_at)
                    .order(:created_at => :desc)
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
    @timelines = query
  end

  def empty_references
    query = Timeline.select(:id, :name, :created_at)
                    .order(:created_at => :desc)
                    .where(nb_references: 0..3)
    if logged_in?
      @like_ids = Like.where(user_id: current_user.id).pluck(:timeline_id)
      if params[:filter] == "mine"
        query = query.where(user_id: current_user.id)
      elsif params[:filter] == "interest"
        query = query.where( id: @like_ids )
      end
    end
    @timelines = query
  end

  def newsletter
  end
end
