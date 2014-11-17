class Melioration < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  validates_uniqueness_of :user_id, :scope => [:comment_id]

  after_create :update_user

  private

  def update_user
    User.increment_counter(:pending_meliorations, self.to_user_id)
  end
end
