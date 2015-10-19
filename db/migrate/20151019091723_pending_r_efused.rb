class PendingREfused < ActiveRecord::Migration
  def change
    add_column :pending_users, :refused, :boolean, default: false
  end
end
