class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :timelines, through: :taggings
  has_many :reference_user_tags, through: :reference_user_taggings
end
