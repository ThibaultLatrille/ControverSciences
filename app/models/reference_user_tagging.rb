class ReferenceUserTagging < ApplicationRecord
  belongs_to :tag
  belongs_to :reference_user_tag
  belongs_to :reference

  validates :reference_user_tag_id, presence: true
  validates :tag_id, presence: true

end