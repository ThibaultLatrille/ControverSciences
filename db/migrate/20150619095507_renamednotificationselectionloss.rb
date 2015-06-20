class Renamednotificationselectionloss < ActiveRecord::Migration
  def change
    drop_table :notification_frame_selection_loss
    create_table :notification_frame_selection_losses do |t|
      t.references :frame, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
