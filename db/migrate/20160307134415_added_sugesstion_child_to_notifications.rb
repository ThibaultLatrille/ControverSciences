class AddedSugesstionChildToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :suggestion_child_id, :integer, index: true
  end
end
