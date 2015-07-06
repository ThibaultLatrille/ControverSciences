class Imgfromframetotimeline < ActiveRecord::Migration
  def change
    change_table :figures do |t|
      t.integer :img_timeline_id, index: true
    end
    add_column :timelines, :figure_id, :integer
    remove_column :frames, :figure_id
    remove_column :figures, :frame_timeline_id
  end
end
