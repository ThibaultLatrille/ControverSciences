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
  has_many :comment_types, dependent: :destroy
  has_many :comment_joins, dependent: :destroy

  after_create :cascading_create_comment

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
  validates :title, length: {maximum: 180}
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

  def balance
    self.f_0_balance + self.f_1_balance + self.f_2_balance +
        self.f_3_balance + self.f_4_balance + self.f_5_balance + self.f_6_balance + self.f_7_balance
  end

  def my_vote( user_id, field )
    vote = Vote.select( :value ).find_by( user_id: user_id, comment_id: self.id, field: field )
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
      unless self["f_#{fi}_content".to_sym ].blank?
        self["markdown_#{fi}".to_sym ] = redcarpet.render(self["f_#{fi}_content".to_sym ])
      end
    end
    unless self.caption.blank?
      self.caption_markdown = redcarpet.render(self.caption)
    end
    unless self.title.blank?
      self.title_markdown = redcarpet.render(self.title)
    end
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


  def selection_update( best_comment = nil, best_user = nil, field = nil )
    NotificationSelectionLoss.create( user_id: best_user,
                                      comment_id: best_comment, field: field )
    Comment.update( best_comment, "f_#{field}_best".to_sym => false )
    best_comment.update_attributes( "f_#{field}_user_id".to_sym => self.user_id,
                    "f_#{field}_comment_id".to_sym => self.id)
    NotificationSelectionWin.create( user_id: self.user_id, comment_id: self.id, field: field)
    NewCommentSelection.create( old_comment_id: best_comment, new_comment_id: self.id, field: field)
    self.update_attributes( "f_#{field}_best".to_sym => true )
  end


  def destroy_with_counters
    empty_best_comment
    nb_votes = self.votes.sum( :value )
    Timeline.decrement_counter( :nb_comments , self.timeline_id )
    Reference.update_counters( self.reference_id, nb_edits: -1 )
    Reference.update_counters( self.reference_id, nb_votes: -nb_votes )
    self.destroy
    refill_best_comment
  end

  def empty_best_comment
    best_comment = BestComment.find_by(reference_id: self.reference_id )
    if best_comment
      for field in 0..7 do
        if best_comment["f_#{field}_comment_id"] == self.id
          best_comment["f_#{field}_user_id"] = nil
          best_comment["f_#{field}_comment_id"] = nil
        end
      end
      best_comment.save
    end
  end

  def fill_best_comment
    best_comment = BestComment.find_by(reference_id: self.reference_id )
    unless best_comment
      best_comment = BestComment.new(reference_id: self.reference_id)
    end
    for field in 0..7 do
      unless best_comment["f_#{field}_user_id"]
        case field
          when 6
            unless self.title.blank?
              best_comment["f_#{field}_user_id"] = self.user_id
              best_comment["f_#{field}_comment_id"] = self.id
              Reference.update( self.reference_id, title_fr: self.title_markdown )
            end
          when 7
            unless self.caption.blank?
              best_comment["f_#{field}_user_id"] = self.user_id
              best_comment["f_#{field}_comment_id"] = self.id
            end
          else
            unless self["f_#{field}_content"].blank?
              best_comment["f_#{field}_user_id"] = self.user_id
              best_comment["f_#{field}_comment_id"] = self.id
            end
        end
      end
    end
    if best_comment.f_6_comment_id == self.id
      Reference.update( self.reference_id, title_fr: self.title_markdown )
    end
    best_comment.save
  end

  def refill_best_comment
    best_comment = BestComment.find_by(reference_id: self.reference_id )
    for field in 0..7 do
      unless best_comment["f_#{field}_user_id"]
        case field
          when 6
            most = Comment.select(:id, :user_id, :title,
                :title_markdown, :reference_id ).where( reference_id: self.reference_id,
                public: true).order(:f_6_score => :desc).first
            if most && !most.title.blank?
              best_comment["f_#{field}_user_id"] = most.user_id
              best_comment["f_#{field}_comment_id"] = most.id
              Reference.update( self.reference_id, title_fr: most.title_markdown )
            end
          when 7
            most = Comment.select(:id, :user_id, :caption ).where( reference_id: self.reference_id,
                                                                   public: true ).order(:f_7_score => :desc).first
            if most && !most.caption.blank?
              best_comment["f_#{field}_user_id"] = most.user_id
              best_comment["f_#{field}_comment_id"] = most.id
            end
          else
            most = Comment.select(:id, :user_id, "f_#{field}_content".to_sym ).where( reference_id: reference_id,
                                                                                      public: true ).order("f_#{field}_score" => :desc).first
            if most && !most["f_#{field}_content"].blank?
              best_comment["f_#{field}_user_id"] = most.user_id
              best_comment["f_#{field}_comment_id"] = most.id
            end
        end
      end
    end
    best_comment.save
  end

  def update_comment_join
    CommentJoin.where(comment_id: self.id).destroy_all
    joins = []
    for fi in 0..7 do
      case fi
        when 6
          unless self.title.blank?
            joins << CommentJoin.new( comment_id: self.id,
                                      reference_id: self.reference_id, field: fi)
          end
        when 7
          unless self.caption.blank?
            joins << CommentJoin.new( comment_id: self.id,
                                      reference_id: self.reference_id, field: fi)
          end
        else
          unless self["f_#{fi}_content".to_sym ].blank?
            joins << CommentJoin.new( comment_id: self.id,
                                      reference_id: self.reference_id, field: fi)
          end
      end
    end
    CommentJoin.import joins
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
    if self.public
      fill_best_comment
      update_comment_join
    else
      if public != self.public
        Vote.where( comment_id: self.id).destroy_all
        empty_best_comment
        refill_best_comment
      end
    end
  end

  def cascading_create_comment
    if self.public
      NewComment.create( comment_id: self.id )
      fill_best_comment
      update_comment_join
    end
    Reference.increment_counter(:nb_edits, self.reference_id)
    Timeline.increment_counter(:nb_comments, self.timeline_id)
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