class AddValuetoEdgeVote < ActiveRecord::Migration
  def change
    add_column :edge_votes, :value, :integer
  end
end
