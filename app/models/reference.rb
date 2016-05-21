class Reference < ActiveRecord::Base
  include ApplicationHelper

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  require 'HTMLlinks'

  attr_accessor :tag_list, :user_binary, :user_rating

  belongs_to :user
  belongs_to :timeline
  has_many :links, dependent: :destroy
  has_many :summary_links, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :binaries, dependent: :destroy
  has_many :reference_contributors, dependent: :destroy
  has_many :reference_edges, dependent: :destroy
  has_many :reference_edges_from, class_name: "ReferenceEdge",
           foreign_key: "target",
           dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one :best_comment, dependent: :destroy
  has_many :reference_user_tags, dependent: :destroy
  has_many :reference_taggings, dependent: :destroy
  has_many :tags, through: :reference_taggings
  has_many :figures, dependent: :destroy
  has_many :dead_links, dependent: :destroy

  around_update :delete_if_review

  after_create :cascading_save_ref
  before_create :binary_timeline

  before_save :to_markdown

  validates :user_id, presence: true
  validates :timeline_id, presence: true

  validates_presence_of :title, :author, :year, :url, :journal
  validates_uniqueness_of :timeline_id, :if => Proc.new { |c| not c.doi.blank? }, :scope => [:doi]

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

  def get_tag_hash
    hash = {}
    reference_user_tags.each do |ref_user_tag|
      ref_user_tag.tags.map(&:name).each do |name|
        hash[name] ? hash[name] += 1 : hash[name] = 1
      end
    end
    hash
  end

  def user_name
    User.select(:name).find(self.user_id).name
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
  end

  def destroy_with_counters
    nb_comments = self.comments.count
    Timeline.decrement_counter(:nb_references, self.timeline_id)
    Timeline.update_counters(self.timeline_id, nb_comments: -nb_comments)
    self.destroy
  end

  def same_doi
    if not self.doi.blank?
      Reference.find_by(doi: self.doi, timeline_id: self.timeline_id)
    else
      false
    end
  end

  def display_year
    if self.year > 1858
      self.year
    else
      "Avant 1859"
    end
  end

  def title_display
    if self.title_fr.blank?
      "Non analysée - #{self.title}".html_safe
    else
      self.title_fr.strip[3..-5].html_safe
    end
  end

  def binary_font_size(value)
    sum = self.binary_1+self.binary_2+self.binary_3+self.binary_4+self.binary_5
    if sum > 0
      1+1.0*self["binary_#{value}"]/sum
    else
      1.5
    end
  end

  def star_font_size(value)
    sum = self.star_1+self.star_2+self.star_3+self.star_4+self.star_5
    if sum > 0
      case value
        when 1
          1+1.0*self.star_1/sum
        when 2
          1+1.0*self.star_2/sum
        when 3
          1+1.0*self.star_3/sum
        when 4
          1+1.0*self.star_4/sum
        when 5
          1+1.0*self.star_5/sum
      end
    else
      1.5
    end
  end

  def update_visite_by_user(user_id)
    visitereference = VisiteReference.find_or_create_by(user_id: user_id, reference_id: self.id)
    VisiteReference.increment_counter(:counter, visitereference.id)
    visitereference.update_columns(updated_at: Time.current)
  end

  private

  def to_markdown
    render_options = {
        filter_html: true,
        hard_wrap: true,
        link_attributes: {rel: 'nofollow'},
        no_images: true,
        no_styles: true,
        safe_links_only: true
    }
    renderer = Redcarpet::Render::HTML.new(render_options)
    extensions = {
        autolink: true,
        lax_spacing: true,
        no_intra_emphasis: true,
        strikethrough: true,
        superscript: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    unless self.abstract.blank?
      self.abstract_markdown = redcarpet.render(self.abstract)
    end
  end

  def delete_if_review
    category = self.category_was
    yield
    if category != self.category
      if self.category == 1
        Comment.where(reference_id: self.id).update_all(f_1_content: '', f_2_content: '',
                                                        markdown_1: '', markdown_2: '',
                                                        f_1_balance: 0, f_2_balance: 0,
                                                        f_1_score: 0.0, f_2_score: 0.0)
        CommentJoin.where(reference_id: self.id, field: 1..2).destroy_all
        Vote.where(reference_id: self.id, field: 1..2).destroy_all
        BestComment.where(reference_id: self.id).update_all(f_1_comment_id: nil, f_2_comment_id: nil,
                                                            f_1_user_id: nil, f_2_user_id: nil)
      elsif self.category == 3 || self.category == 4
        Comment.where(reference_id: self.id).update_all(f_2_content: '', markdown_2: '',
                                                        f_2_balance: 0, f_2_score: 0.0)
        CommentJoin.where(reference_id: self.id, field: 2).destroy_all
        Vote.where(reference_id: self.id, field: 2).destroy_all
        BestComment.where(reference_id: self.id).update_all(f_2_comment_id: nil, f_2_user_id: nil)
      end
    end
  end

  def binary_timeline
    self.binary = Timeline.select(:binary).find(self.timeline_id).binary
  end

  def cascading_save_ref
    Timeline.increment_counter(:nb_references, self.timeline_id)
    ReferenceContributor.create({user_id: self.user_id, reference_id: self.id, bool: true})
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.timeline_id})
      TimelineContributor.create({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
    end
    notifications = []
    Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
      unless self.user_id == user_id
        notifications << Notification.new(user_id:      user_id, timeline_id: self.timeline_id,
                                          reference_id: self.id, category: 2)
      end
    end
    Notification.import notifications
  end

end
