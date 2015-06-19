class FrameTaggings < ActiveRecord::Migration
  def change
    create_table :frame_taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :frame, index: true

      t.timestamps
    end
  end
end
