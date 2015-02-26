class MyItemsController < ApplicationController
  before_action :logged_in_user, only: [:items, :votes]

  def items
    @timelines = Timeline.select(:id, :name).where( user_id: current_user.id)
    @references = Reference.select(:id, :timeline_id, :title).where( user_id: current_user.id)
    @comments = Comment.select(:id, :timeline_id, :reference_id,
                               :title_markdown, :balance, :public ).where( user_id: current_user.id)
    @summaries = Summary.select(:id, :timeline_id, :content, :balance, :public ).where( user_id: current_user.id)
  end

  def votes
    @votes = Vote.where( user_id: current_user.id)
    @credits = Credit.where( user_id: current_user.id)
  end

end
