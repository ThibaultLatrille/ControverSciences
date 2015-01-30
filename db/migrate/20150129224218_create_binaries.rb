class CreateBinaries < ActiveRecord::Migration
  def change
    create_table :binaries do |t|
      t.references :timeline, index: true
      t.references :reference, index: true
      t.references :user, index: true
      t.integer :value

      t.timestamps
    end
  end
end
