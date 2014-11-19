class FollowingsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @fo_new_timelines = FollowingNewTimeline.find_by_user_id( current_user.id )
    list_timelines = FollowingTimeline.where( user_id: current_user.id ).pluck( :timeline_id )
    @fo_timelines = Timeline.where( id: list_timelines ).pluck( :id, :name )
    list_references = FollowingReference.where( user_id: current_user.id ).pluck( :reference_id )
    @fo_references = Reference.where( id: list_references ).pluck( :id, :title_fr )
  end
end