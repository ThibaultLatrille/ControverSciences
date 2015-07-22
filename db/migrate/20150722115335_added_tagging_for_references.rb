class AddedTaggingForReferences < ActiveRecord::Migration
  def change
    create_table :reference_taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :reference, index: true

      t.timestamps
    end
  end
end
