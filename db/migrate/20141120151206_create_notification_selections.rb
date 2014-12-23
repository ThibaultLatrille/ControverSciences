class CreateNotificationSelections < ActiveRecord::Migration
  def change
    create_table :notification_selections do |t|
      t.references :user, index: true
      t.integer :new_comment_id
      t.integer :old_comment_id

      t.timestamps
    end
  end
end
