class FollowingsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    tag_ids = FollowingNewTimeline.where( user_id: current_user.id ).pluck( :tag_id )
    @fo_new_timelines = Tag.where( id: tag_ids ).pluck( :id, :name )
    timeline_ids = FollowingTimeline.where( user_id: current_user.id ).pluck( :timeline_id )
    @fo_timelines = Timeline.where( id: timeline_ids ).pluck( :id, :name )
    reference_ids = FollowingReference.where( user_id: current_user.id ).pluck( :reference_id )
    @fo_references = Reference.where( id: reference_ids ).pluck( :id, :title_fr )
  end
end