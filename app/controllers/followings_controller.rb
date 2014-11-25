class FollowingsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    tag_ids = FollowingNewTimeline.where( user_id: current_user.id ).pluck( :tag_id )
    @fo_new_timelines = Tag.select(:id, :name).where( id: tag_ids )
    timeline_ids = FollowingTimeline.where( user_id: current_user.id ).pluck( :timeline_id )
    @fo_timelines = Timeline.select(:id, :name ).where( id: timeline_ids )
    reference_ids = FollowingReference.where( user_id: current_user.id ).pluck( :reference_id )
    @fo_references = Reference.select( :id, :title_fr ).where( id: reference_ids )
  end
end