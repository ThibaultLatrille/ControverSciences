class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :reference, index: true
      t.references :timeline, index: true
      t.references :user, index: true
      t.integer :value

      t.timestamps
    end
  end
end
