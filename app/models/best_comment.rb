class BestComment < ActiveRecord::Base
  belongs_to :reference

  validates :reference_id, presence: true
  validates_uniqueness_of :reference_id

  def not_empty
    !f_0_comment_id.nil? || !f_1_comment_id.nil? ||
        !f_2_comment_id.nil? || !f_3_comment_id.nil? || !f_4_comment_id.nil? || !f_5_comment_id.nil? ||
        !f_6_comment_id.nil? || !f_7_comment_id.nil?
  end

  def authors
    list = []
    for fi in 0..7 do
      list << self["f_#{fi}_user_id".to_sym]
    end
    list.compact.uniq
  end

  def user_name( fi )
    User.select( :name ).find( self["f_#{fi}_user_id".to_sym] ).name
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
    Comment.select( :id, :picture ).find( self.f_7_comment_id ).picture_url
  end

end
