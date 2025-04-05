class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.datetime :delivery_at, null: false
      t.integer :headcount, null: false
      t.string :status, null: false, default: 'pending'
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :delivery_fee, precision: 10, scale: 2
      t.decimal :tax_amount, precision: 10, scale: 2
      t.decimal :total_amount, precision: 10, scale: 2
      t.text :special_instructions
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
	# Add index for status
    add_index :orders, :status

	# Optional: Index delivery_at if you query by date/time often
    # add_index :orders, :delivery_at
  end
end
