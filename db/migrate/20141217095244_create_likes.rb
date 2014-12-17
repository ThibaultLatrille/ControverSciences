class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :timeline
      t.text :ip

      t.timestamps
    end
    add_index :likes, [:ip, :timeline_id], unique: true
  end
end
