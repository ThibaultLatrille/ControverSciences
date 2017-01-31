class ReferenceTagging < ApplicationRecord
  belongs_to :tag
  belongs_to :reference
end
