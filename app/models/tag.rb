class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :timelines, through: :taggings
  has_many :reference_user_taggings, dependent: :destroy
  has_many :reference_user_tags, through: :reference_user_taggings
  has_many :reference_taggings, dependent: :destroy
  has_many :references, through: :reference_taggings
  has_many :tag_pair_sources, class_name: "TagPair", foreign_key: "tag_theme_source", dependent: :destroy
  has_many :tag_pair_targets, class_name: "TagPair", foreign_key: "tag_theme_target", dependent: :destroy
end
