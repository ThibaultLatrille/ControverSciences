class AddPendingMeliorationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pending_meliorations, :integer, default: 0
    add_column :users, :waiting_meliorations, :integer, default: 0
  end
end
