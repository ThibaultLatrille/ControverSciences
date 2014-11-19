class Timeline < ActiveRecord::Base
  attr_accessor :tag_list
  belongs_to :user
  has_many :timeline_contributors, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :taggings
  has_many :tags, through: :taggings

  after_create :cascading_save_timeline

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 180 }

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
      list = %w(chemistry biology physics economy planet social immunity pharmacy animal plant space pie)
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

  private

  def create_notifications
    nil
  end

  def cascading_save_timeline
      self.create_notifications
      timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.id, bool: true})
      timrelation.save()
      Timeline.increment_counter(:nb_contributors, self.id)
  end
end
