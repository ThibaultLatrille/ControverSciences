class AddSuggestionToNotifications < ActiveRecord::Migration
  def change
    change_table :notifications do |t|
      t.references :suggestion, index: true
    end
  end
end
