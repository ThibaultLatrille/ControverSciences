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
      list = tags_hash.keys
      self.tags = names.map do |n|
        if list.include? n
          Tag.where(name: n.strip).first_or_create!
        end
      end
    end
  end

end
