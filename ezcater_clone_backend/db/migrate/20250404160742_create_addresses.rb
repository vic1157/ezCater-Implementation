class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :nickname
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.boolean :is_default, default: false
      t.datetime :last_used_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
