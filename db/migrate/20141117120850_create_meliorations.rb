class CreateMeliorations < ActiveRecord::Migration
  def change
    create_table :meliorations do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.integer :to_user_id, index: true
      t.text :content
      t.text :message
      t.boolean :pending, default: true
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end
