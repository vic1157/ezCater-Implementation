class CreateSavedRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :saved_restaurants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end

	# Add a unique

  end
end
