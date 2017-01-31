class BestComment < ApplicationRecord
  belongs_to :reference
  include Contribution

  validates :reference_id, presence: true
  validates_uniqueness_of :reference_id

  def not_empty
    !f_0_comment_id.nil? || !f_1_comment_id.nil? ||
        !f_2_comment_id.nil? || !f_3_comment_id.nil? || !f_4_comment_id.nil? || !f_5_comment_id.nil? ||
        !f_6_comment_id.nil? || !f_7_comment_id.nil?
  end

  def first_data
    if !f_0_comment_id.blank?
      markdown( 0 )
    elsif !f_1_comment_id.blank?
      markdown( 1 )
    elsif !f_2_comment_id.blank?
      markdown( 2 )
    elsif !f_3_comment_id.blank?
      markdown( 3 )
    elsif !f_4_comment_id.blank?
      markdown( 4 )
    elsif !f_5_comment_id.blank?
      markdown( 5 )
    else
      "<p></p>"
    end
  end

  def authors
    self.editors.length + self.contributors.count
  end

  def editors
    (0..7).map{ |fi| self["f_#{fi}_user_id".to_sym] }.compact.uniq
  end

  def contributors
    ContributorComment.where(comment_id: (0..7).map{ |fi| self["f_#{fi}_comment_id".to_sym] }.compact.uniq)
  end

  def user_name( fi=false )
    User.select( :name ).find( fi.present? ? self["f_#{fi}_user_id".to_sym] : self.editors.first ).name
  end

  def user_id
    self.editors.first
  end

  def user_fi_id( fi )
    self["f_#{fi}_user_id".to_sym]
  end

  def reference_title
    Reference.select( :title ).find( self.reference_id ).title
  end

  def file_name
    User.select( :email ).find(self.user_id).email.partition("@")[0].gsub(".", "_" ) + "_ref_#{self.reference_id}"
  end

  def markdown( fi )
    case fi
      when 6
        Comment.select( :title_markdown ).find( self.f_6_comment_id ).title_markdown
      when 7
        Comment.select( :caption_markdown ).find( self.f_7_comment_id ).caption_markdown
      else
        Comment.select( "markdown_#{fi}".to_sym ).find( self["f_#{fi}_comment_id".to_sym] )["markdown_#{fi}".to_sym]
    end
  end

  def comment_count( fi )
    CommentJoin.where( reference_id: self.reference_id, field: fi ).count
  end

  def picture_url
    Comment.select( :id, :figure_id ).find( self.f_7_comment_id ).picture_url
  end

end
