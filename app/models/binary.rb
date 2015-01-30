class Binary < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :reference
  belongs_to :user

  after_create  :cascading_save_binary
  around_update  :cascading_update_binary
  around_destroy  :cascading_destroy_binary

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :value, presence: true, inclusion: { in: 1..5 }
  validates_uniqueness_of :user_id, :scope => [:reference_id]

  private

  def cascading_save_binary
    Reference.update_counters( self.reference_id, "binary_#{self.value}".to_sym => 1 )
    update_most_binary
  end

  def cascading_destroy_binary
    old_value = self.value_was
    reference_id = self.reference_id
    yield
    Reference.update_counters( reference_id, "binary_#{old_value}".to_sym => -1 )
  end

  def cascading_update_binary
    old_value = self.value_was
    yield
    Reference.update_counters( self.reference_id, "binary_#{old_value}".to_sym => -1 )
    Reference.update_counters( self.reference_id, "binary_#{self.value}".to_sym => 1 )
    update_most_binary
  end

  def update_most_binary
    ref = Reference.find( self.reference_id )
    dico = { 1 => ref.binary_1, 2 => ref.binary_2,
             3 => ref.binary_3, 4 => ref.binary_4,
             5 => ref.binary_5}
    most = dico.max_by{ |k,v| v }
    if ref.binary_most != most[0] && most[1]>3
      v_to_symbol = { 1 => :binary_1, 2 => :binary_2,
                      3 => :binary_3, 4 => :binary_4,
                      5 => :binary_5}
      if ref.binary_counted
        Timeline.increment_counter(v_to_symbol[most[0]], self.timeline_id)
        Timeline.decrement_counter(v_to_symbol[ref.binary_most], self.timeline_id)
      else
        Timeline.increment_counter(v_to_symbol[most[0]], self.timeline_id)
        ref.update({:binary_counted => true})
      end
      ref.update({binary_most: most[0]})
    end
  end
end
