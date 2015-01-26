class Timeline < ActiveRecord::Base
  include ApplicationHelper

  attr_accessor :tag_list
  belongs_to :user
  has_many :timeline_contributors, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :ratings
  has_many :comments
  has_many :links
  has_many :votes

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :following_timelines, dependent: :destroy
  has_many :notification_timelines, dependent: :destroy

  after_create :cascading_save_timeline

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 180 }

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def star_percent( value )
    if self.nb_references > 0
      case value
        when 1
          self.star_1*100/self.nb_references
        when 2
          self.star_2*100/self.nb_references
        when 3
          (self.nb_references - self.star_1 - self.star_2 - self.star_4 - self.star_5)*100/self.nb_references
        when 4
          self.star_4*100/self.nb_references
        when 5
          self.star_5*100/self.nb_references
      end
    else
      0
    end
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).timelines
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
        joins(:taggings).group("taggings.tag_id")
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

  def compute_score( nb_contributors, nb_references, nb_edits )
    3.0/(1.0/(1+Math.log(1+nb_contributors))+1.0/(1+Math.log(1+10*nb_references))+1.0/(1+Math.log(1+5*nb_edits)))
  end

  private

  def cascading_save_timeline
    NewTimeline.create( timeline_id: self.id )
    timrelation = TimelineContributor.create({user_id: self.user_id, timeline_id: self.id, bool: true})
    timrelation.save()
    Timeline.increment_counter(:nb_contributors, self.id)
  end
end
