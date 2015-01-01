class CreateSuggestionChildVotes < ActiveRecord::Migration
  def change
    create_table :suggestion_child_votes do |t|
      t.references :suggestion_child
      t.boolean :value
      t.inet :ip

      t.timestamps
    end
    add_index :suggestion_child_votes, [:ip, :suggestion_child_id], unique: true
  end
end
