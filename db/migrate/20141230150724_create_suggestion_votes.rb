class CreateSuggestionVotes < ActiveRecord::Migration
  def change
    create_table( :suggestion_votes, force: true) do |t|
      t.references :suggestion
      t.boolean :value
      t.inet :ip

      t.timestamps
    end
    add_index :suggestion_votes, [:ip, :suggestion_id], unique: true
  end
end
