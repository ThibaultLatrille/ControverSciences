class AddReferenceEdge < ActiveRecord::Migration
  def change
    create_table :reference_edges do |t|
      t.references :timeline, index: true
      t.references :reference, index: true
      t.integer :target, index: true
      t.integer :weight, default: 1
      t.references :user, index: true
      t.boolean :reversible

      t.timestamps
    end
    create_table :reference_edge_votes do |t|
      t.references :timeline, index: true
      t.references :reference, index: true
      t.integer :target, index: true
      t.references :user, index: true
      t.boolean :reversible

      t.timestamps
    end
  end
end
