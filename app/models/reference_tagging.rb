class ReferenceTagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :reference
end
