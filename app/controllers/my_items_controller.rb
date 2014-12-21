class MyItemsController < ApplicationController
  def timelines
    @timelines = Timeline.select(:id, :name).where( user_id: current_user.id)
  end

  def references
    @references = Reference.select(:id, :timeline_id, :title_fr).where( user_id: current_user.id)
  end

  def comments
    @comments = Comment.select(:id, :timeline_id, :reference_id,
                               :f_1_content, :balance ).where( user_id: current_user.id)
  end

  def summaries
    @summaries = Summary.select(:id, :timeline_id, :content, :balance ).where( user_id: current_user.id)
  end

  def votes
    @votes = Vote.where( user_id: current_user.id)
    @credits = Credit.where( user_id: current_user.id)
  end

  def drafts
    @comment_drafts = CommentDraft.select(:id, :timeline_id, :reference_id,
                                 :f_1_content).where( user_id: current_user.id)
    @summary_drafts = SummaryDraft.select(:id, :timeline_id,
                                  :content).where( user_id: current_user.id)
  end
end
