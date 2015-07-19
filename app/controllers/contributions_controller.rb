class ContributionsController < ApplicationController
  def index
    @contrib_timelines = Timeline.all.pluck(:created_at)
    @contrib_references = Reference.all.pluck(:created_at)
    @contrib_users = User.all.pluck(:created_at)
    @contrib_comments = Comment.all.pluck(:created_at)
    @contrib_summaries = Summary.all.pluck(:created_at)
  end
end
