class CreateNotificationSummarySelections < ActiveRecord::Migration
  def change
    create_table :notification_summary_selections do |t|
      t.references :user, index: true
      t.integer :old_summary_id
      t.integer :new_summary_id

      t.timestamps
    end
  end
end
