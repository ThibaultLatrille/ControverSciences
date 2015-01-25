class CreateNewReferences < ActiveRecord::Migration
  def change
    create_table :new_references do |t|
      t.references :reference, index: true

      t.timestamps
    end
  end
end
