class CreateLikes < ActiveRecord::Migration
  def change
    create_table( :likes, force: true) do |t|
      t.references :timeline
      t.inet :ip

      t.timestamps
    end
    add_index :likes, [:ip, :timeline_id], unique: true
  end
end
