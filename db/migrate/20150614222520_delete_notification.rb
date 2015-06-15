class DeleteNotification < ActiveRecord::Migration
  def change
    drop_table :notification_typos
  end
end
