class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.references :timeline
      t.references :reference, index: true
      t.references :comment, index: true
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
