class ChangeTableToAccomodateFrame < ActiveRecord::Migration
  def change
    add_column :timelines, :nb_frames, :integer, :default => 0
    add_column :timelines, :frame, :text, :default => ""
    add_column :users, :nb_notifs, :integer, :default => 0
    change_table :notifications do |t|
      t.references :frame, index: true
    end
    change_table :typos do |t|
      t.references :frame, index: true
    end
    create_table :notification_frame_selection_wins do |t|
      t.references :frame, index: true
      t.references :user, index: true

      t.timestamps
    end
    create_table :notification_frame_selection_loss do |t|
      t.references :frame, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
