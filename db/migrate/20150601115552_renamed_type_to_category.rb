class RenamedTypeToCategory < ActiveRecord::Migration
  def change
    rename_column :notifications, :type, :category
  end
end
