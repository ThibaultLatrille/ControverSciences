class CreateVisiteReferences < ActiveRecord::Migration
  def change
    create_table :visite_references do |t|
      t.references :user, index: true
      t.references :reference, index: true

      t.timestamps
    end
    add_index :visite_references, [:user_id, :reference_id], unique: true
  end
end
