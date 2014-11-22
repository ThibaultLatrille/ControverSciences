class Comment < ActiveRecord::Base
  require 'HTMLlinks'

  attr_accessor :diff

  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  has_many :votes, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :child_relationships, class_name: "CommentRelationship",
           foreign_key: "parent_id",
           dependent: :destroy
  has_one :parent_relationship, class_name: "CommentRelationship",
             foreign_key: "child_id",
             dependent: :destroy

  has_many :children, class_name: "Comment", through: :child_relationships, source: :child

  has_one :parent, class_name: "Comment", through: :parent_relationship, source: :parent

  after_create :cascading_save_comment

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :content, presence: true
  validates :field, presence: true, inclusion: { in: 1..5 }
  #validates_uniqueness_of :user_id, :scope => [:reference_id, :field]

  def markdown(root_url)
    render_options = {
        # will remove from the output HTML tags inputted by user
        filter_html:     true,
        # will insert <br /> tags in paragraphs where are newlines
        # (ignored by default)
        hard_wrap:       true,
        # hash for extra link options, for example 'nofollow'
        link_attributes: { rel: 'nofollow' },
        # more
        # will remove <img> tags from output
        no_images: true,
        # will remove <a> tags from output
        # no_links: true
        # will remove <style> tags from output
        no_styles: true,
        # generate links for only safe protocols
        safe_links_only: true
        # and more ... (prettify, with_toc_data, xhtml)
    }

    renderer = HTMLlinks.new(render_options)
    renderer.links = []
    renderer.ref_url = root_url+"references/"

    extensions = {
        #will parse links without need of enclosing them
        autolink:           true,
        # blocks delimited with 3 ` or ~ will be considered as code block.
        # No need to indent.  You can provide language name too.
        # ```ruby
        # block of code
        # ```
        #fenced_code_blocks: true,
        # will ignore standard require for empty lines surrounding HTML blocks
        lax_spacing:        true,
        # will not generate emphasis inside of words, for example no_emph_no
        no_intra_emphasis:  true,
        # will parse strikethrough from ~~, for example: ~~bad~~
        strikethrough:      true,
        # will parse superscript after ^, you can wrap superscript in ()
        superscript:        true
        # will require a space after # in defining headers
        # space_after_headers: true
    }
    self.content_markdown = Redcarpet::Markdown.new(renderer, extensions).render(self.content)
    renderer.links
  end

  def save_with_markdown( root_url, user_id)
    links = self.markdown(root_url)
    if self.save
      reference_ids = Reference.where(timeline_id: self.timeline_id).pluck(:id)
      links.each do |link|
        if reference_ids.include? link
          Link.create({comment_id: self.id, user_id: user_id,
                       reference_id: link, timeline_id: self.timeline_id})
        end
      end
      true
    else
      false
    end
  end

  def create_notifications
    user_ids = FollowingReference.where( reference_id: self.reference_id ).pluck( :user_id )
    notifications = []
    user_ids.each do |user_id|
      notifications << NotificationComment.new( user_id: user_id, comment_id: self.id )
    end
    NotificationComment.import notifications
    User.increment_counter( :notifications_comment, user_ids)
  end

  private

  def cascading_save_comment
    self.create_notifications
    reference = self.reference
    if reference["f_#{self.field}_content".to_sym].nil?
      reference.displayed_comment( self)
    end
    Reference.increment_counter(:nb_edits, self.reference_id)
    Timeline.increment_counter(:nb_edits, self.timeline_id)
    unless TimelineContributor.where({user_id: self.user_id, timeline_id: self.timeline_id}).any?
      timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
      timrelation.save
      Timeline.increment_counter(:nb_contributors, self.timeline_id)
    end
    unless ReferenceContributor.where({user_id: self.user_id, reference_id: self.reference_id}).any?
      refrelation=ReferenceContributor.new({user_id: self.user_id, reference_id: self.reference_id, bool: true})
      refrelation.save
      Reference.increment_counter(:nb_contributors, self.reference_id)
    end
  end
end