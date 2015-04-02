class UserDetail < ActiveRecord::Base
  belongs_to :user
  attr_accessor :delete_picture, :has_picture

  def picture?
    self.figure_id ? true : false
  end

  def picture_url
    if self.figure_id
      Figure.select( :id, :picture, :user_id ).find( self.figure_id ).picture_url
    else
      nil
    end
  end
end
