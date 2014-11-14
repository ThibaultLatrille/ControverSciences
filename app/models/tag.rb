class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :timelines, through: :taggings
end
