class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  has_many :votes, dependent: :destroy

  after_create :cascading_save_comment

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :content, presence: true
  validates :field, presence: true, inclusion: { in: 1..5 }
  validates_uniqueness_of :user_id, :scope => [:reference_id, :field]

  def markdown
    render_options = {
        # will remove from the output HTML tags inputted by user
        filter_html:     true,
        # will insert <br /> tags in paragraphs where are newlines
        # (ignored by default)
        hard_wrap:       true,
        # hash for extra link options, for example 'nofollow'
        link_attributes: { rel: 'nofollow' }
        # more
        # will remove <img> tags from output
        # no_images: true
        # will remove <a> tags from output
        # no_links: true
        # will remove <style> tags from output
        # no_styles: true
        # generate links for only safe protocols
        # safe_links_only: true
        # and more ... (prettify, with_toc_data, xhtml)
    }
    renderer = Redcarpet::Render::HTML.new(render_options)

    extensions = {
        #will parse links without need of enclosing them
        autolink:           true,
        # blocks delimited with 3 ` or ~ will be considered as code block.
        # No need to indent.  You can provide language name too.
        # ```ruby
        # block of code
        # ```
        fenced_code_blocks: true,
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
    Redcarpet::Markdown.new(renderer, extensions).render(self.content).html_safe
  end

  private

  def cascading_save_comment
      reference = self.reference
      if reference.field_id( self.field ).nil?
        reference.displayed_comment( self )
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