class Summary < ActiveRecord::Base
  require 'HTMLlinks'

  attr_accessor :parent_id, :draft_id

  belongs_to :user
  belongs_to :timeline

  has_many :credits, dependent: :destroy
  has_many :summary_links, dependent: :destroy

  has_many :child_relationships, class_name: "SummaryRelationship",
           foreign_key: "parent_id",
           dependent: :destroy
  has_one :parent_relationship, class_name: "SummaryRelationship",
          foreign_key: "child_id",
          dependent: :destroy
  has_many :children, class_name: "Summary", through: :child_relationships, source: :child
  has_one :parent, class_name: "Summary", through: :parent_relationship, source: :parent

  has_one :summary_best, dependent: :destroy

  after_create :cascading_save_summary

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :content, presence: true

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def my_credit( user_id )
    credit = Credit.select( :value ).find_by( user_id: user_id, summary_id: self.id )
    if credit
      credit.value
    else
      0
    end
  end

  def to_markdown( timeline_url)
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
    self.markdown = Redcarpet::Markdown.new(renderer, extensions).render(self.content)
    renderer.links
  end

  def save_with_markdown( timeline_url )
    links = self.to_markdown( timeline_url )
    if self.save
      reference_ids = Reference.where(timeline_id: self.id).pluck(:id)
      links.each do |link|
        if reference_ids.include? link
          SummaryLink.create({summary_id: self.id, user_id: self.user_id,
                       reference_id: link, timeline_id: self.id})
        end
      end
      FollowingSummary.create( user_id: self.user_id,
                                 timeline_id: self.id)
      true
    else
      false
    end
  end

  def selection_update( best_summary = nil )
    if best_summary
      Summary.update( best_summary.summary_id, best: false )
      best_summary.update_attributes( user_id: self.user_id, summary_id: self.id )
    else
      SummaryBest.create( user_id: self.user_id,
                          summary_id: self.id, timeline_id: self.timeline_id)
    end
    self.update_attributes( best: true)
  end
  
  def create_notifications
    user_ids = FollowingSummary.where( timeline_id: self.id ).pluck( :user_id )
    notifications = []
    user_ids.each do |user_id|
      notifications << NotificationSummary.new( user_id: user_id, summary_id: self.id )
    end
    NotificationSummary.import notifications
  end


  def destroy_with_counters
    Timeline.decrement_counter( :nb_edits , self.timeline_id )
    self.destroy
  end

  private

  def cascading_save_summary
    self.create_notifications
    best_summary = SummaryBest.find_by(timeline_id: self.id )
    unless best_summary
      self.selection_update
    end
    Timeline.increment_counter(:nb_edits, self.timeline_id)
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.id})
      timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.id, bool: true})
      timrelation.save
      Timeline.increment_counter(:nb_contributors, self.id)
    end
  end
end
