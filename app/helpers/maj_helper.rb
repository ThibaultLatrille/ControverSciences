module MajHelper
  def destroy_empty_notifs
    Notification.where(timeline_id: nil, reference_id: nil, summary_id: nil, comment_id: nil, like_id: nil, field: nil, frame_id: nil).destroy_all
  end

  def maj_counter
    ApplicationRecord.transaction do
      Timeline.find_each do |timeline|
        timeline.update_columns(nb_comments: Comment.where(timeline_id: timeline.id).count,
                                nb_references: Reference.where(timeline_id: timeline.id).where.not(title_fr: '').count)
      end
    end
  end

  def maj_refill
    ApplicationRecord.transaction do
      Reference.find_each.map {|r| r.comments.map(&:save)}
      Timeline.find_each.map {|t| t.summaries.map(&:save)}
      Timeline.find_each.map {|t| t.frames.map(&:save)}
    end
  end

  def maj_update_binary
    ApplicationRecord.transaction do
      Timeline.find_each do |timeline|
        timeline.reset_binary(timeline.binary, Frame.find_by(timeline_id: timeline.id, best: true).id)
      end
      Timeline.find_each.map {|t| t.references.each {|r| r.update_columns(binary: t.binary)}}
    end
  end

  def maj_content
    ApplicationRecord.transaction do
      Summary.find_each.map {|t| t.save!}
      Comment.find_each.map {|t| t.save!}
      Frame.find_each.map {|t| t.save!}
    end
  end

  def maj_to_markdown
    ApplicationRecord.transaction do
      Summary.find_each.map {|t| t.update_with_markdown}
      Comment.find_each.map {|t| t.update_with_markdown}
      Frame.find_each.map {|t| t.save_with_markdown}
      Reference.find_each.map {|t| t.save}
    end
  end
end
