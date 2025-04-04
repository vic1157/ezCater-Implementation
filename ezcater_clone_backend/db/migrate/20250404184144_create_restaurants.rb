class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.text :description
      t.string :address
      t.string :phone_number
      t.string :image_url
      t.decimal :minimum_order_amount, precision: 10, scale: 2
      t.decimal :delivery_fee, precision: 10, scale: 2
      t.float :rating

      t.timestamps
    end
  end
end
