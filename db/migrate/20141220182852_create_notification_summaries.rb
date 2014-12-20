class CreateNotificationSummaries < ActiveRecord::Migration
  def change
    create_table :notification_summaries do |t|
      t.references :user, index: true
      t.references :summary, index: true

      t.timestamps
    end
  end
end
