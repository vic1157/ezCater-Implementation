class Restaurant < ApplicationRecord
	has_many :saved_restaurants, dependent: :destroy
	has_many :users, through: :saved_restaurants
end
