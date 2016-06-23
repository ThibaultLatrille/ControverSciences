module MajHelper

  def maj_v_15
    ActiveRecord::Base.transaction do
      score = 0
      Question.all.each do |question|
        question.update_attribute(:score, score)
        score += 1
      end
    end
  end

  def maj_counter
    ActiveRecord::Base.transaction do
      Timeline.find_each do |timeline|
        timeline.update_columns(nb_comments: Comment.where(timeline_id: timeline.id).count,
                                nb_references: Reference.where(timeline_id: timeline.id).where.not(title_fr: '').count)
      end
    end
  end

  def maj_refill
    ActiveRecord::Base.transaction do
      Reference.find_each.map{|r| r.comments.map(&:save)}
      Timeline.find_each.map{|t| t.summaries.map(&:save)}
      Timeline.find_each.map{|t| t.frames.map(&:save)}
    end
  end


  def maj_v_14
    ActiveRecord::Base.transaction do
      UserDetail.find_each do |user_detail|
        unless user_detail.send_email
          user_detail.frequency = 0
          user_detail.save
        end
      end
    end
  end

  def maj_v_13
    ActiveRecord::Base.transaction do
      Timeline.where.not(binary: '').find_each do |timeline|
        Binary.where(timeline_id: timeline.id).update_all(frame_id: Frame.select(:id).find_by(timeline_id: timeline.id, best: true).id )
      end
    end
  end
end
