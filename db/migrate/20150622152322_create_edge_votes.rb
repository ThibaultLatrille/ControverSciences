class CreateEdgeVotes < ActiveRecord::Migration
  def change
    create_table :edge_votes do |t|
      t.references :edge, index: true
      t.references :user, index: true
      t.references :timeline, index: true

      t.timestamps
    end
    add_column :edges, :reversible, :boolean, default: false
  end
end
