class CreateNotificationSelectionns < ActiveRecord::Migration
  def change
    create_table :notification_selections do |t|
      t.references :timeline, index: true
      t.references :reference, index: true
      t.references :frame, index: true
      t.references :comment, index: true
      t.references :summary, index: true
      t.references :user, index: true
      t.boolean :win
      t.integer :field

      t.timestamps
    end
    drop_table :notification_frame_selection_losses
    drop_table :notification_frame_selection_wins
    drop_table :notification_summary_selection_losses
    drop_table :notification_summary_selection_wins
    drop_table :notification_selection_losses
    drop_table :notification_selection_wins
  end
end
