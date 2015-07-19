class ContributionsController < ApplicationController
  def index
    @contrib_timelines = Timeline.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    @contrib_references = Reference.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    @contrib_users = User.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    @contrib_comments = Comment.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    @contrib_summaries = Summary.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
  end
end
