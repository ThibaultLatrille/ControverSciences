class CreateSuggestionChildren < ActiveRecord::Migration
  def change
    create_table :suggestion_children do |t|
      t.references :user, index: true
      t.references :suggestion, index: true
      t.text :comment
      t.string :email
      t.string :name
      t.integer :balance, default: 0
      t.integer :plus, default: 0
      t.integer :minus, default: 0

      t.timestamps
    end
  end
end
