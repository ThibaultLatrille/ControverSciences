class ReferenceUserTag < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :reference
  belongs_to :user

  attr_accessor :tag_list

  has_many :reference_user_taggings, dependent: :destroy
  has_many :tags, through: :reference_user_taggings

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_id]

  def self.tagged_with(name)
    Tag.find_by_name!(name).timelines
  end

  def self.tag_counts
    Tag.select("tags.*, count(reference_user_taggings.tag_id) as count").
        joins(:taggings).group("reference_user_taggings.tag_id")
  end

  def get_tag_list
    tags.map(&:name)
  end

  def set_tag_list(names)
    if !names.nil?
      puts "BIMMMM"
      puts tags_hash

      list = tags_hash.keys
      self.tags = names.map do |n|
        if list.include? n
          Tag.where(name: n.strip).first_or_create!
        end
      end
    end
  end

  def update_tags
    ref = self.reference
    tags = ref.get_tag_list.sort
    tag_hash = ref.get_tag_hash
    new_tags = tag_hash.sort_by {|k,v| v}.last(3).map{ |x| x.first }.sort
    if new_tags != tags
      ref.set_tag_list(new_tags)
      tim = ref.timeline
      tim_tags = tim.get_tag_list.sort
      tim_tag_hash = tim.get_tag_hash
      new_tim_tags = tim_tag_hash.sort_by {|k,v| v}.last(3).map{ |x| x.first }.sort
      if new_tim_tags != tim_tags
        tim.set_tag_list(new_tim_tags)
      end
    end
  end

end
