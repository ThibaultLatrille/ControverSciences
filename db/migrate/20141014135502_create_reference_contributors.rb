class CreateReferenceContributors < ActiveRecord::Migration
  def change
    create_table :reference_contributors do |t|
      t.references :user, index: true
      t.references :reference, index: true
      t.boolean :bool

      t.timestamps
    end
  end
end
