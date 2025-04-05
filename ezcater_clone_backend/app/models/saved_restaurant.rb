class SavedRestaurant < ApplicationRecord
	belongs_to :user
	belongs_to :restaurant

	# Ensure the combination of user_id and restaurant_id is unique at the model level too
	validates: user_id, uniqueness: { scope: :restaurant_id, message: "has already saved this restaurant"}
end
