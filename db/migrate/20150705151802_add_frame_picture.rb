class AddFramePicture < ActiveRecord::Migration
  def change
    change_table :figures do |t|
      t.integer :frame_timeline_id, index: true
    end
    add_column :frames, :figure_id, :integer
  end
end
