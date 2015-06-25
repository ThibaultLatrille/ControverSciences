class AddReversibleToEdgeVote < ActiveRecord::Migration
  def change
    remove_column :edge_votes, :value
    remove_column :edge_votes, :edge_id
    add_column :edge_votes, :reversible, :boolean, default: false
    add_column :edge_votes, :target, :integer, index: true
  end
end
