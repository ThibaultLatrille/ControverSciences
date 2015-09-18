class DeleteNotificationSelection < ActiveRecord::Migration
  def change
    drop_table :notification_suggestions
  end
end
