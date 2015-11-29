class RemovedTypos < ActiveRecord::Migration
  def change
    drop_table :typos
    remove_column :users, :my_typos
    remove_column :users, :target_typos
  end
end
