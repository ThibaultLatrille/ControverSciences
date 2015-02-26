class Comment < ActiveRecord::Base
  require 'HTMLlinks'

  attr_accessor :parent_id, :delete_picture

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

  has_many :notification_comments, dependent: :destroy
  has_many :notification_selection_losses, dependent: :destroy
  has_many :notification_selection_wins, dependent: :destroy
  has_many :notification_selections, foreign_key: "new_comment_id", dependent: :destroy

  has_one :best_comment, dependent: :destroy

  after_create :cascading_save_comment

  around_update :updating_with_public

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :f_0_content, length: {maximum: 1001}
  validates :f_1_content, length: {maximum: 1001}
  validates :f_2_content, length: {maximum: 1001}
  validates :f_3_content, length: {maximum: 1001}
  validates :f_4_content, length: {maximum: 1001}
  validates :f_5_content, length: {maximum: 1001}
  validates :caption, length: {maximum: 1001}
  validates :title, length: {maximum: 180}, presence: true
  validate  :picture_size
  validates_uniqueness_of :user_id, :scope => :reference_id

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def reference_title
    Reference.select( :title ).find( self.reference_id ).title
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def file_name
    User.select( :email ).find(self.user_id).email.partition("@")[0].gsub(".", "_" ) + "_ref_#{self.reference_id}"
  end

  def my_vote( user_id )
    vote = Vote.select( :value ).find_by( user_id: user_id, comment_id: self.id )
    if vote
      vote.value
    else
      0
    end
  end

  def markdown( timeline_url)
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
    renderer.ref_url = '#ref-'

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
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    for fi in 0..5
      self["markdown_#{fi}".to_sym ] = redcarpet.render(self["f_#{fi}_content".to_sym ])
    end
    self.caption_markdown = redcarpet.render(self.caption)
    self.title_markdown = redcarpet.render(self.title)
    renderer.links
  end

  def save_with_markdown( timeline_url )
    links = self.markdown( timeline_url)
    if self.save
      reference_ids = Reference.where(timeline_id: self.timeline_id).pluck(:id)
      links.each do |link|
        if reference_ids.include? link
          Link.create({comment_id: self.id, user_id: self.user_id,
                       reference_id: link, timeline_id: self.timeline_id})
        end
      end
      FollowingReference.create( user_id: self.user_id,
                                 reference_id: self.reference_id)
      true
    else
      false
    end
  end

  def update_with_markdown( timeline_url )
    Link.where( user_id: user_id, comment_id: id ).destroy_all
    save_with_markdown( timeline_url )
  end


  def selection_update( best_comment = nil )
    if best_comment
      old_comment_id = best_comment.comment_id
      NotificationSelectionLoss.create( user_id: best_comment.user_id,
                                        comment_id: best_comment.comment_id)
      Comment.update( best_comment.comment_id, best: false )
      best_comment.update_attributes( user_id: self.user_id, comment_id: self.id )
      NotificationSelectionWin.create( user_id: self.user_id, comment_id: self.id)
      NewCommentSelection.create( old_comment_id: old_comment_id, new_comment_id: self.id )
    else
      BestComment.create( user_id: self.user_id, reference_id: self.reference_id,
                          comment_id: self.id)
    end
    Reference.update( self.reference_id, title_fr: self.title_markdown )
    self.update_attributes( best: true)
  end


  def destroy_with_counters
    nb_votes = self.votes.count
    Timeline.decrement_counter( :nb_edits , self.timeline_id )
    Reference.update_counters( self.reference_id, nb_edits: -1 )
    Reference.update_counters( self.reference_id, nb_votes: -nb_votes )
    self.destroy
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, 'Taille de la figure supérieure à 5 Mo, veuillez réduire la taille de celle-ci.')
    end
  end

  def updating_with_public
    public = self.public_was
    yield
    if public != self.public
      if self.public
        test =  BestComment.where( reference_id: self.reference_id).nil?
        unless test
          BestComment.create( user_id: self.user_id, reference_id: self.reference_id,
                              comment_id: self.id)
        end
      else
        Vote.where( comment_id: self.id).destroy_all
        if self.best
          BestComment.where( reference_id: self.reference_id).destroy_all
        end
      end
    end
    if self.best
      Reference.update( self.reference_id, title_fr: self.title_markdown )
    end
  end

  def cascading_save_comment
    NewComment.create( comment_id: self.id )
    best_comment = BestComment.find_by(reference_id: self.reference_id )
    unless best_comment
      self.selection_update
    end
    Reference.increment_counter(:nb_edits, self.reference_id)
    Timeline.increment_counter(:nb_edits, self.timeline_id)
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.timeline_id})
      timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
      timrelation.save
      Timeline.increment_counter(:nb_contributors, self.timeline_id)
    end
    unless ReferenceContributor.find_by({user_id: self.user_id, reference_id: self.reference_id})
      refrelation=ReferenceContributor.new({user_id: self.user_id, reference_id: self.reference_id, bool: true})
      refrelation.save
      Reference.increment_counter(:nb_contributors, self.reference_id)
    end
  end
end