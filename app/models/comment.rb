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

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def reference_title
    Reference.select( :title_fr ).find( self.reference_id ).title_fr
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

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
    for fi in 1..5
      self["markdown_#{fi}".to_sym ] = Redcarpet::Markdown.new(renderer, extensions).render(self["f_#{fi}_content".to_sym ])
    end
    renderer.links
  end

  def diffy( comment )
    self.diff = {}
    for fi in 1..5
      self.diff[fi] = Diffy::Diff.new(comment["f_#{fi}_content".to_sym ], self["f_#{fi}_content".to_sym ],
                                     :include_plus_and_minus_in_html => true).to_s(:html)
    end
  end

  def save_with_markdown( root_url )
    links = self.markdown(root_url)
    if self.save
      reference_ids = Reference.where(timeline_id: self.timeline_id).pluck(:id)
      links.each do |link|
        if reference_ids.include? link
          Link.create({comment_id: self.id, user_id: self.user_id,
                       reference_id: link, timeline_id: self.timeline_id})
        end
      end
      true
    else
      false
    end
  end


  def selection_update( best_comment = nil )
    if best_comment
      NotificationSelectionLoss.create( user_id: best_comment.user_id,
                                        comment_id: best_comment.comment_id)
      User.increment_counter( :notifications_loss, best_comment.user_id)
      Comment.find( best_comment.comment_id ).update_attributes( best: false )
      best_comment.update_attributes( user_id: comment.user_id, comment_id: comment.id )
      NotificationSelectionWin.create( user_id: comment.user_id, comment_id: comment.id)
      User.increment_counter( :notifications_win, comment.user_id )
      self.selection_notifications
    else
      BestComment.create( user_id: self.user_id, reference_id: self.reference_id,
                          comment_id: self.id)
    end
    Reference.find( self.reference_id ).update_attributes( f_1_content: self.markdown_1,
                                                           f_2_content: self.markdown_2,
                                                           f_3_content: self.markdown_3,
                                                           f_4_content: self.markdown_4,
                                                           f_5_content: self.markdown_5)
    self.update_attributes( best: true)
  end

  def selection_notifications
    ids = Comment.where( reference_id: self.reference_id ).pluck(:id, :user_id )
    notifications = []
    user_ids = []
    comment_ids = []
    ids.each do |comment_id, user_id|
      user_ids << user_id
      comment_ids << comment_id
      notifications << NotificationSelection.new( user_id: user_id, comment_id: comment_id )
    end
    NotificationSelection.import notifications
    User.increment_counter( :notifications_selection, user_ids)
    Comment.where(id: comment_ids).update_all(votes_plus: 0, votes_minus: 0, balance: 0 )
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


  def destroy_with_counters
    nb_votes = self.votes.count
    Timeline.decrement_counter( :nb_comments , self.timeline_id )
    Reference.update_counters( self.reference_id, nb_edits: -1 )
    Reference.update_counters( self.reference_id, nb_votes: -nb_votes )
    self.destroy
  end

  private

  def cascading_save_comment
    self.create_notifications
    best_comment = BestComment.find_by(reference_id: self.reference_id )
    unless best_comment
      self.selection_update
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