class NotificationGenerated < ActiveRecord::Migration
  def change
    add_column :comments, :notif_generated, :boolean, default: false
    add_column :summaries, :notif_generated, :boolean, default: false
  end
end
