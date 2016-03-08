module NotificationsHelper
  def sym_to_int_notifs_hash
    {timeline: 1,
     reference: 2,
     summary: 3,
     summary_selection: 4,
     comment: 5,
     selection: 6,
     frame: 8,
     frame_selection: 9,
     suggestion: 10,
     suggestion_child: 11}
  end

  def notification_model_query(category)
    if category == 6
      Notification.where(user_id: current_user.id, category: 6)
    else
      case category
        when 1
          query = Timeline.includes(:tags).select(:id, :slug, :name, :user_id)
        when 2
          query = Reference.select(:id, :slug, :timeline_id, :title, :user_id)
        when 3, 4
          query = Summary.select(:id, :timeline_id, :user_id)
        when 5
          query = Comment.select(:id, :timeline_id, :reference_id, :user_id)
        when 8, 9
          query = Frame.select(:id, :timeline_id, :user_id)
        when 10
          query = Suggestion.select(:id, :comment, :name, :user_id)
        when 11
          query = SuggestionChild.select(:id, :comment, :name, :user_id)
        else
          query = nil
      end
      query.joins(:notifications).where(notifications: {user_id: current_user.id, category: category})
    end
  end

  def category_to_model_hash
    {1 => :timeline_id,
     2 => :reference_id,
     3 => :summary_id,
     4 => :summary_id,
     5 => :comment_id,
     6 => :comment_id,
     8 => :frame_id,
     9 => :frame_id,
     10 => :suggestion_id,
     11 => :suggestion_child_id}
  end
end
