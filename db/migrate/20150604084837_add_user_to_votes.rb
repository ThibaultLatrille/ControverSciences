class AddUserToVotes < ActiveRecord::Migration
  def change
    change_table :suggestion_votes do |t|
      t.references :user, index: true
      t.remove :ip
    end
    change_table :suggestion_child_votes do |t|
      t.references :user, index: true
      t.remove :ip
    end
  end
end
