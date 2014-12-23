class CreateNotificationSummarySelectionWins < ActiveRecord::Migration
  def change
    create_table :notification_summary_selection_wins do |t|
      t.references :summary, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
