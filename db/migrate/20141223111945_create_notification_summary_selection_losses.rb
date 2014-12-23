class CreateNotificationSummarySelectionLosses < ActiveRecord::Migration
  def change
    create_table :notification_summary_selection_losses do |t|
      t.references :user, index: true
      t.references :summary, index: true

      t.timestamps
    end
  end
end
