class Comment < ActiveRecord::Base
  require 'HTMLlinks'
  include ApplicationHelper

  attr_accessor :delete_picture, :has_picture

  belongs_to :user
  belongs_to :timeline
  belongs_to :reference

  has_many :votes, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many :notifications, dependent: :destroy
  has_many :notification_selections, dependent: :destroy
  has_many :comment_joins, dependent: :destroy
  has_many :go_patches, dependent: :destroy

  after_create :cascading_create_comment

  around_update :updating_with_public

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validate :content_validation
  validates :caption, length: {maximum: 1001}
  validates :title, length: {maximum: 180}
  validates_uniqueness_of :user_id, :scope => :reference_id

  def user_name
    User.select(:name).find(self.user_id).name
  end

  def reference_title
    Reference.select(:title).find(self.reference_id).title
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
  end

  def picture?
    self.figure_id ? true : false
  end

  def empty_field?(field)
    case field
      when 6
        self.title.blank?
      when 7
        !self.figure_id
      else
        self["f_#{field}_content"].blank?
    end
  end

  def field_content(field)
    case field
      when 6
        self.title
      when 7
        self.caption
      else
        self["f_#{field}_content"]
    end
  end

  def picture_url
    if self.figure_id
      Figure.select(:id, :picture, :user_id).find(self.figure_id).picture_url
    else
      nil
    end
  end

  def category
    self.reference.category
  end

  def balance
    self.f_0_balance + self.f_1_balance + self.f_2_balance +
        self.f_3_balance + self.f_4_balance + self.f_5_balance + self.f_6_balance + self.f_7_balance
  end

  def my_vote(user_id, field)
    vote = Vote.select(:value).find_by(user_id: user_id, comment_id: self.id, field: field)
    if vote
      vote.value
    else
      0
    end
  end

  def get_most_comment(field)
    ids = CommentJoin.where(reference_id: self.reference_id, field: field).pluck(:comment_id)
    if field == 6
      most = Comment.select(:id, :reference_id, :timeline_id, :title_markdown, :user_id, :f_6_balance).where(id: ids).order(:f_6_balance => :desc).first
    else
      most = Comment.select(:id, :reference_id, :timeline_id, :user_id, "f_#{field}_balance".to_sym).where(id: ids).order("f_#{field}_balance".to_sym => :desc).first
    end
    most
  end

  def is_same_as_best
    flag         = false
    best_comment = BestComment.find_by(reference_id: self.reference_id)
    if best_comment
      for field in 0..7 do
        if best_comment["f_#{field}_comment_id"] && !self.empty_field?(field)
          if field == 6
            com = Comment.select(:id, :title).find(best_comment["f_#{field}_comment_id"])
            if com.title == self.title
              self.title = ""
              flag       = true
            end
          elsif field == 7
            com = Comment.select(:id, :caption).find(best_comment["f_#{field}_comment_id"])
            if com.caption == self.caption
              self.title = ""
              flag       = true
            end
          else
            com = Comment.select(:id, "f_#{field}_content").find(best_comment["f_#{field}_comment_id"])
            if com["f_#{field}_content"] == self["f_#{field}_content"]
              self["f_#{field}_content"] = ""
              flag                       = true
            end
          end
        end
      end
    end
    flag
  end

  def markdown
    render_options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: {rel: 'nofollow'},
        no_images:       true,
        no_styles:       true,
        safe_links_only: true
    }

    renderer       = HTMLlinks.new(render_options)
    renderer.links = {}
    renderer.counter = 1
    if Rails.env.production?
      renderer.root_url = "https://controversciences.org"
    else
      renderer.root_url = "http://127.0.0.1:3000"
    end

    extensions = {
        autolink:          true,
        lax_spacing:       true,
        no_intra_emphasis: true,
        strikethrough:     true,
        superscript:       true
    }
    redcarpet  = Redcarpet::Markdown.new(renderer, extensions)
    for fi in 0..5
      unless self.empty_field?(fi)
        self["markdown_#{fi}".to_sym] = redcarpet.render(self["f_#{fi}_content".to_sym])
      end
    end
    unless self.empty_field?(7)
      self.caption_markdown = redcarpet.render(self.caption)
    end
    unless self.empty_field?(6)
      self.title_markdown = redcarpet.render(self.title)
    end
    renderer.links
  end

  def save_with_markdown
    links = self.markdown
    if self.save
      reference_ids = Reference.where(timeline_id: self.timeline_id).pluck(:id)
      links.each do |link, value|
        if reference_ids.include? link
          Link.create({comment_id:   self.id, user_id: self.user_id, count: value,
                       reference_id: link, timeline_id: self.timeline_id})
        end
      end
      true
    else
      false
    end
  end

  def update_with_markdown
    Link.where(user_id: user_id, comment_id: id).destroy_all
    save_with_markdown
  end


  def selection_update(best_comment = nil, comment_id = nil, user_id = nil, field = nil, only_win = false)
    if user_id
      Notification.where(timeline_id: self.timeline_id,
                         reference_id: self.reference_id, field: field, category: 6).destroy_all

      unless only_win
        NotificationSelection.create(user_id:    user_id, timeline_id: self.timeline_id,
                                     reference_id: self.reference_id,
                                         comment_id: comment_id, field: field, win: false)
      end
      NotificationSelection.create(user_id: self.user_id, timeline_id: self.timeline_id,
                                      reference_id: self.reference_id,
                                      comment_id: self.id, field: field, win: true)
      notifications = []
      Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |like_user_id|
        unless self.user_id == like_user_id || user_id == like_user_id
          notifications << Notification.new(user_id:      like_user_id, timeline_id: self.timeline_id,
                                            reference_id: self.reference_id, field: field,
                                            comment_id:   self.id, category: 6)
        end
      end
      Notification.import notifications
    end
    if field == 6
      Reference.update(self.reference_id, title_fr: self.title_markdown)
    end
    best_comment["f_#{field}_user_id".to_sym]    = self.user_id
    best_comment["f_#{field}_comment_id".to_sym] = self.id
    best_comment
  end

  def empty_best_comment
    best_comment = BestComment.find_by(reference_id: self.reference_id)
    if best_comment
      for field in 0..7 do
        if best_comment["f_#{field}_comment_id"] == self.id
          best_comment["f_#{field}_user_id"]    = nil
          best_comment["f_#{field}_comment_id"] = nil
          if field == 6
            Reference.update(self.reference_id, title_fr: "")
            Timeline.update(self.timeline_id, nb_references: Reference.where(timeline_id: self.timeline_id).where.not(title_fr: "").count)
          end
        end
      end
      best_comment.save
    end
  end

  def fill_best_comment
    best_comment = BestComment.find_by(reference_id: self.reference_id)
    unless best_comment
      best_comment = BestComment.new(reference_id: self.reference_id)
    end
    for field in 0..7 do
      if not best_comment["f_#{field}_user_id"]
        unless self.empty_field?(field)
          best_comment["f_#{field}_user_id"]    = self.user_id
          best_comment["f_#{field}_comment_id"] = self.id
          if field == 6
            Reference.update(self.reference_id, title_fr: self.title_markdown)
            Timeline.update(self.timeline_id, nb_references: Reference.where(timeline_id: self.timeline_id).where.not(title_fr: "").count)
          end
        end
      elsif best_comment["f_#{field}_user_id"] == self.user_id
        if self.empty_field?(field)
          most = get_most_comment(field)
          if most
            most.selection_update(best_comment, self.id, self.user_id, field)
          else
            best_comment["f_#{field}_user_id"]    = nil
            best_comment["f_#{field}_comment_id"] = nil
            if field == 6
              Reference.update(self.reference_id, title_fr: "")
              Timeline.update(self.timeline_id, nb_references: Reference.where(timeline_id: self.timeline_id).where.not(title_fr: "").count)
            end
          end
        elsif field == 6
          Reference.update(self.reference_id, title_fr: self.title_markdown)
          Timeline.update(self.timeline_id, nb_references: Reference.where(timeline_id: self.timeline_id).where.not(title_fr: "").count)
        end
      end
    end
    best_comment.save
  end

  def refill_best_comment
    best_comment = BestComment.find_by(reference_id: self.reference_id)
    for field in 0..7 do
      unless best_comment["f_#{field}_user_id"]
        most = get_most_comment(field)
        if most
          best_comment = most.selection_update(best_comment, self.id, self.user_id, field, true)
        end
      end
    end
    best_comment.save
  end

  def update_best_field(field)
    best_comment = BestComment.find_by(reference_id: self.reference_id)
    unless best_comment
      best_comment = BestComment.new(reference_id: self.reference_id)
    end
    most = get_most_comment(field)
    if most
      if (most.id != best_comment["f_#{field}_comment_id".to_sym]) && (most["f_#{field}_balance"] > (best_comment["f_#{field}_comment_id".to_sym] + 1))
        most.selection_update(best_comment,
                              best_comment["f_#{field}_comment_id".to_sym],
                              best_comment["f_#{field}_user_id".to_sym], field).save
      end
    end
  end

  def update_comment_join
    CommentJoin.where(comment_id: self.id).destroy_all
    joins = []
    for fi in 0..7 do
      unless self.empty_field?(fi)
        joins << CommentJoin.new(comment_id:   self.id,
                                 reference_id: self.reference_id, field: fi)
      end
    end
    CommentJoin.import joins
  end

  def destroy_with_counters
    empty_best_comment
    if self.public
      Timeline.decrement_counter(:nb_comments, self.timeline_id)
      Reference.update_counters(self.reference_id, nb_edits: -1)
    else
      User.decrement_counter(:nb_private, self.user_id)
    end
    self.destroy
    refill_best_comment
  end

  private

  def content_validation
    if self.public
      ref = self.reference
      (category_limit[ref.category].keys - [6, 7] ).each do |field|
        if self["f_#{field}_content".to_sym] && self["f_#{field}_content".to_sym].length > category_limit[ref.category][field]
          errors.add("f_#{field}_content".to_sym, category_hash[ref.category][field] + " est trop long (pas plus de #{category_limit[ref.category][field]} caractères)")
        end
      end
      if ref.title_fr.blank? && self.title.blank?
        errors.add(:title, 'doit être spécifié dans l\'analyse')
      end
      if ref.nb_edits == 0 && self.f_0_content.blank? &&
          self.f_1_content.blank? && self.f_2_content.blank? &&
          self.f_3_content.blank? && self.f_4_content.blank? &&
          self.f_5_content.blank? && self.caption.blank?
        errors.add(:base, "Un titre seul n'est pas une analyse !")
      end
    end
  end

  def updating_with_public
    public = self.public_was
    yield
    if self.public
      update_comment_join
      fill_best_comment
      unless self.notif_generated
        notifications = []
        Notification.where( timeline_id: self.timeline_id,
            reference_id: self.reference_id,
            comment_id:   self.id, category: 5).destroy_all
        Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
          unless self.user_id == user_id
            notifications << Notification.new(user_id:      user_id, timeline_id: self.timeline_id,
                                              reference_id: self.reference_id,
                                              comment_id:   self.id, category: 5)
          end
        end
        Notification.import notifications
        Reference.increment_counter(:nb_edits, self.reference_id)
        Timeline.increment_counter(:nb_comments, self.timeline_id)
        User.decrement_counter(:nb_private, self.user_id)
        self.update_columns(notif_generated: true)
      end
    else
      if public != self.public
        CommentJoin.where(comment_id: self.id).destroy_all
        Vote.where(comment_id: self.id).destroy_all
        empty_best_comment
        refill_best_comment
        Reference.decrement_counter(:nb_edits, self.reference_id)
        Timeline.decrement_counter(:nb_comments, self.timeline_id)
        User.increment_counter(:nb_private, self.user_id)
        self.update_columns(notif_generated: false)
      end
    end
  end

  def cascading_create_comment
    if self.public
      update_comment_join
      fill_best_comment
      notifications = []
      Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
        unless self.user_id == user_id
          notifications << Notification.new(user_id:      user_id, timeline_id: self.timeline_id,
                                            reference_id: self.reference_id,
                                            comment_id:   self.id, category: 5)
        end
      end
      Notification.import notifications
      self.update_columns(notif_generated: true)
      Reference.increment_counter(:nb_edits, self.reference_id)
      Timeline.increment_counter(:nb_comments, self.timeline_id)
    else
      User.increment_counter(:nb_private, self.user_id)
    end
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.timeline_id})
      TimelineContributor.create({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
    end
    unless ReferenceContributor.find_by({user_id: self.user_id, reference_id: self.reference_id})
      ReferenceContributor.create({user_id: self.user_id, reference_id: self.reference_id, bool: true})
    end
  end

end