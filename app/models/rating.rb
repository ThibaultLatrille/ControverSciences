class Rating < ApplicationRecord
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
    update_most_stared
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
    if most[1] > 0
      if ref.star_most != most[0]
        ref.update_columns({star_most: most[0]})
      end
    else
      ref.update_columns({star_most: 0})
    end
  end
end
