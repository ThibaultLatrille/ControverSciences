class ModifiedEdgeVote < ActiveRecord::Migration
  def change
    change_table :edge_votes do |t|
      t.references :edge, index: true
    end
    add_column :edge_votes, :value, :integer
    remove_column :edge_votes, :target
    remove_column :edge_votes, :timeline_id
    remove_column :edge_votes, :reversible
  end
end
