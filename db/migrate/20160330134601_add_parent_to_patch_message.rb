class AddParentToPatchMessage < ActiveRecord::Migration
  def change
    change_table :patch_messages do |t|
      t.integer :comment_id, index: true
      t.integer :frame_id, index: true
      t.integer :summary_id, index: true
    end
  end
end
