class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.references :reference, index: true
      t.references :timeline, index: true

      t.timestamps
    end
  end
end
