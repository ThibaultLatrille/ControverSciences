class Typo < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary
  belongs_to :comment

  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  after_create :cascading_create_typo

  private

  def cascading_create_typo
    NotificationTypo.create(user_id: self.target_user, typo_id: self.id)
  end

end
