class CreatePartnerLoves < ActiveRecord::Migration
  def change
    create_table :partner_loves do |t|
      t.references :partner, index: true
      t.references :user, index: true

      t.timestamps
    end
    add_column :partners, :loves, :integer, default: 0
  end
end
