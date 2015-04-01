class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.references :user, index: true
      t.text :comment
      t.string :email
      t.string :name
      t.integer :timeline_id
      t.integer :balance, default: 0
      t.integer :plus, default: 0
      t.integer :minus, default: 0

      t.timestamps
    end
  end
end
