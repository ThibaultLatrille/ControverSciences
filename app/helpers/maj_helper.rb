module MajHelper
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
      Timeline.where.not(binary: "").find_each do |timeline|
        Binary.where(timeline_id: timeline.id).update_all(frame_id: Frame.select(:id).find_by(timeline_id: timeline.id, best: true).id )
      end
    end
  end
end
