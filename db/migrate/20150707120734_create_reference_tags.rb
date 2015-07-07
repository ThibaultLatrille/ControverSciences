class CreateReferenceTags < ActiveRecord::Migration
  def change
    create_table :reference_user_tags do |t|
      t.references :reference, index: true
      t.references :timeline, index: true
      t.references :user, index: true

      t.timestamps
    end
    create_table :reference_taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :reference_tag, index: true

      t.timestamps
    end
    create_table :reference_user_taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :reference_user_tag, index: true

      t.timestamps
    end
    drop_table :frame_taggings
  end
end
