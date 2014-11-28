class Rating < ActiveRecord::Base
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user

  after_create  :cascading_save_rating
  around_update  :cascading_update_rating
  around_destroy  :cascading_destroy_rating

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :value, presence: true, inclusion: { in: 1..5 }
  validates_uniqueness_of :user_id, :scope => [:reference_id]

  private

  def cascading_save_rating
    Reference.update_counters( self.reference_id, "star_#{self.value}".to_sym => 1 )
    update_most_stared
  end

  def cascading_destroy_rating
    old_value = self.value_was
    reference_id = self.reference_id
    yield
    Reference.update_counters( reference_id, "star_#{old_value}".to_sym => -1 )
  end

  def cascading_update_rating
    old_value = self.value_was
    yield
    Reference.update_counters( self.reference_id, "star_#{old_value}".to_sym => -1 )
    Reference.update_counters( self.reference_id, "star_#{self.value}".to_sym => 1 )
    update_most_stared
  end

  def update_most_stared
    ref = Reference.find( self.reference_id )
    dico = { 1 => ref.star_1, 2 => ref.star_2,
            3 => ref.star_3, 4 => ref.star_4,
            5 => ref.star_5}
    most = dico.max_by{ |k,v| v }
    if ref.star_most != most[0] && most[1]>3
      v_to_symbol = { 1 => :star_1, 2 => :star_2,
                      3 => :star_3, 4 => :star_4,
                      5 => :star_5}
      if ref.star_counted
        Timeline.increment_counter(v_to_symbol[most[0]], self.timeline_id)
        Timeline.decrement_counter(v_to_symbol[ref.star_most], self.timeline_id)
      else
        Timeline.increment_counter(v_to_symbol[most[0]], self.timeline_id)
        ref.update({:star_counted => true})
      end
      ref.update({star_most: most[0]})
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
