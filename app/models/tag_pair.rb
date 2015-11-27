class TagPair < ActiveRecord::Base
  belongs_to :tag_source, class_name: "Tag", foreign_key: "tag_theme_source"
  belongs_to :tag_target, class_name: "Tag", foreign_key: "tag_theme_target"
end
