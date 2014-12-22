class SelectionJob
  include AssisstantHelper

  def perform
    update_score_users
    update_score_timelines
    compute_fitness
    selection_events
    ids = Timeline.all.pluck( :id )
    Timeline.update_counters( ids , nb_likes: 100 )
  end
end