class AddPendingMeliorationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pending_meliorations, :integer, default: 0
  end
end
