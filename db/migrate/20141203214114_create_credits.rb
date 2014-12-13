class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :summary, index: true
      t.integer :value

      t.timestamps
    end
  end
end
