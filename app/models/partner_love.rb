class PartnerLove < ActiveRecord::Base
  belongs_to :partner
  belongs_to :user

  validates :user_id, presence: true
  validates :partner_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:partner_id]

  after_create  :cascading_save_like
  after_destroy :cascading_destroy_like

  private

  def cascading_save_like
    Partner.update_counters(self.partner_id, loves: 1 )
  end

  def cascading_destroy_like
    Partner.update_counters(self.partner_id, loves: -1 )
  end
end
