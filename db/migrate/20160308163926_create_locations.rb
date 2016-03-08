class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :user, index: true
      t.references :suggestion, index: true
      t.references :suggestion_child, index: true
      t.text :ip_address
      t.text :user_agent
      t.float :latitude
      t.float :longitude
      t.text :address

      t.timestamps
    end
  end
end
