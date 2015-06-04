class Timeline < ActiveRecord::Base
  include ApplicationHelper

  attr_accessor :tag_list, :binary_left, :binary_right
  belongs_to :user
  has_many :timeline_contributors, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :summaries, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :notifications, dependent: :destroy
  has_one :suggestion, dependent: :destroy

  after_create :cascading_save_timeline

  around_update :updating_with_params

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 180 }
  validate :binary_valid

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def nb_edits
    self.nb_summaries + self.nb_comments
  end

  def total_binary
    self.binary_1+self.binary_2+self.binary_3+self.binary_4+self.binary_5
  end

  def nb_suggestions
    nb = self.suggestion.children
    if nb == 0
      ""
    elsif nb == 1
      " (#{nb} réponse)"
    else
      " (#{nb} réponses)"
    end
  end

  def binary_font_size( value )
    if self.nb_references > 0
      case value
        when 1
          1+1.5*self.binary_1/self.nb_references
        when 2
          1+1.5*self.binary_2/self.nb_references
        when 3
          1+1.5*(self.binary_0+self.binary_3)/self.nb_references
        when 4
          1+1.5*self.binary_4/self.nb_references
        when 5
          1+1.5*self.binary_5/self.nb_references
      end
    else
      1.5
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

  def binary_valid
    if self.binary != ""
      if self.binary.split('&&')[0].blank?
        errors.add(:base, "Un des antagoniste est vide")
      elsif self.binary.split('&&')[0].length > 20
        errors.add(:base, "Un des antagoniste est trop long (>20 caractères)")
      end
      if self.binary.split('&&')[1].blank?
        errors.add(:base, "Un des antagoniste est vide")
      elsif self.binary.split('&&')[1].length > 20
        errors.add(:base, "Un des antagoniste est trop long (>20 caractères)")
      end
    end
  end

  def cascading_save_timeline
    text = "Discussion libre autour de la controverse : **#{self.name.strip}**"
    Suggestion.create( user_id: self.user_id, timeline_id: self.id, comment: text )
    notifications = []
    User.all.pluck(:id).each do |user_id|
      notifications << Notification.new( user_id: user_id, timeline_id: self.id, category: 1 )
    end
    Notification.import notifications
    TimelineContributor.create({user_id: self.user_id, timeline_id: self.id, bool: true})
  end

  def updating_with_params
    sug = Suggestion.find_by( timeline_id: self.id )
    sug.comment = "Discussion libre autour de la controverse : **#{self.name.strip}**"
    sug.save
    binary = self.binary_was
    yield
    if binary != self.binary
      Reference.where( timeline_id: self.id ).update_all(:binary => self.binary )
    end
  end

end
