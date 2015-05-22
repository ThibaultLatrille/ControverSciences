class Reference < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  has_many :links
  has_many :votes
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :binaries, dependent: :destroy
  has_many :reference_contributors, dependent: :destroy

  has_many :following_references, dependent: :destroy
  has_many :notification_references, dependent: :destroy

  has_one :best_comment, dependent: :destroy

  around_update :delete_if_review

  after_create  :cascading_save_ref
  before_create  :binary_timeline

  validates :user_id, presence: true
  validates :timeline_id, presence: true

  validates_presence_of :title, :author, :year, :url, :journal
  validates_uniqueness_of :timeline_id, :if => Proc.new {|c| not c.doi.blank?}, :scope => [:doi]

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def destroy_with_counters
    nb_comments = self.comments.count
    Timeline.decrement_counter( :nb_references , self.timeline_id)
    Timeline.update_counters( self.timeline_id, nb_comments: -nb_comments )
    self.destroy
  end

  def same_doi
    if not self.doi.blank?
      Reference.find_by( doi: self.doi, timeline_id: self.timeline_id )
    else
      false
    end
  end

  def display_year
    if self.year > 1958
      self.year
    else
      "Avant 1858"
    end
  end

  def title_display
    if self.title_fr && !self.title_fr.blank?
      self.title_fr.html_safe
    else
      self.title
    end
  end

  def binary_font_size( value )
    sum = self.binary_1+self.binary_2+self.binary_3+self.binary_4+self.binary_5
    if sum > 0
      case value
        when 1
          1+1.0*self.binary_1/sum
        when 2
          1+1.0*self.binary_2/sum
        when 3
          1+1.0*self.binary_3/sum
        when 4
          1+1.0*self.binary_4/sum
        when 5
          1+1.0*self.binary_5/sum
      end
    else
      1.5
    end
  end

  def star_font_size( value )
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

  private

  def delete_if_review
    article = self.article_was
    yield
    if article != self.article && !self.article
      Comment.where( reference_id: self.id ).update_all( f_1_content: "", f_2_content: "",
                                                         markdown_1: "", markdown_2: "",
                                                         f_1_balance: 0, f_2_balance: 0,
                                                         f_1_score: 0.0, f_2_score: 0.0)
      CommentJoin.where( reference_id: self.id, field: 1..2 ).destroy_all
      Vote.where( reference_id: self.id, field: 1..2 ).destroy_all
      BestComment.where( reference_id: self.id ).update_all( f_1_comment_id: nil, f_2_comment_id: nil,
                                                             f_1_user_id: nil, f_2_user_id: nil)
    end
  end

  def binary_timeline
    self.binary = Timeline.select( :binary ).find( self.timeline_id ).binary
  end

  def cascading_save_ref
    NewReference.create( reference_id: self.id )
    Timeline.increment_counter(:nb_references, self.timeline_id)
    Timeline.increment_counter(:binary_0, self.timeline_id)
    ReferenceContributor.create({user_id: self.user_id, reference_id: self.id, bool: true})
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.timeline_id})
      TimelineContributor.create({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
    end
  end

end
