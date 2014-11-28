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

  def compute_score( nb_references, nb_comments, nb_votes )
    return 1.0/(1.0/(1+Math.log(1+nb_references))+1.0/(1+Math.log(1+0.1*nb_comments))+1.0/(1+Math.log(1+0.001*nb_votes)))
  end

  def create_notifications
    tag_ids = self.tags.pluck(:id)
    user_ids = FollowingNewTimeline.where( tag_id: tag_ids ).pluck( :user_id )
    user_ids.uniq!
    notifications = []
    user_ids.each do |user_id|
      notifications << NotificationTimeline.new( user_id: user_id, timeline_id: self.id )
    end
    NotificationTimeline.import notifications
  end

  private

  def cascading_save_timeline
    self.create_notifications
    timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.id, bool: true})
    timrelation.save()
    Timeline.increment_counter(:nb_contributors, self.id)
  end
end
