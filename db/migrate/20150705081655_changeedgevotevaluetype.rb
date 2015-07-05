class Changeedgevotevaluetype < ActiveRecord::Migration
  def change
    remove_column :edge_votes, :value, :integer
    add_column :edge_votes, :value, :boolean
  end
end
