class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :timelines, through: :taggings
  has_many :frames, through: :frame_taggings

end
