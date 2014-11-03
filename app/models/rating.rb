class Rating < ActiveRecord::Base
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user

  after_create  :cascading_save_rating
  around_update  :cascading_update_rating

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :value, presence: true, inclusion: { in: 1..5 }
  validates_uniqueness_of :user_id, :scope => [:reference_id]

  private

  def cascading_save_rating
    self.increment_stars_counter(self.value)
    Reference.increment_counter(:nb_votes, self.reference_id)
    Timeline.increment_counter(:nb_votes, self.timeline_id)
    ref = self.reference
    most = { 1 => ref.star_1, 2 => ref.star_2,
             3 => ref.star_3, 4 => ref.star_4,
             5 => ref.star_5}.max_by{ |k,v| v }[0]
    if ref.star_most != most
      ref.star_most = most
    end
  end

  def cascading_update_rating
    old_value = self.value_was
    yield
    self.decrement_stars_counter(old_value)
    self.increment_stars_counter(self.value)
    ref = self.reference
    most = { 1 => ref.star_1, 2 => ref.star_2,
             3 => ref.star_3, 4 => ref.star_4,
             5 => ref.star_5}.max_by{ |k,v| v }[0]
    if ref.star_most != most
      ref.star_most = most
    end
  end

  def increment_stars_counter(value)
    case value
      when 1
        Reference.increment_counter(:star_1, self.reference_id)
      when 2
        Reference.increment_counter(:star_2, self.reference_id)
      when 3
        Reference.increment_counter(:star_3, self.reference_id)
      when 4
        Reference.increment_counter(:star_4, self.reference_id)
      when 5
        Reference.increment_counter(:star_5, self.reference_id)
    end
  end

  def decrement_stars_counter(value)
    case value
      when 1
        Reference.decrement_counter(:star_1, self.reference_id)
      when 2
        Reference.decrement_counter(:star_2, self.reference_id)
      when 3
        Reference.decrement_counter(:star_3, self.reference_id)
      when 4
        Reference.decrement_counter(:star_4, self.reference_id)
      when 5
        Reference.decrement_counter(:star_5, self.reference_id)
    end
  end
end
