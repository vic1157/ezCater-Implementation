# app/graphql/types/restaurant_type.rb
module Types
	class RestaurantType < Types::BaseObject
	  description "Represents a restaurant or caterer available on the platform"
  
	  field :id, ID, null: false
	  field :name, String, null: false
	  field :description, String, null: true
	  field :address, String, null: true, description: "Formatted address string of the restaurant" # (Could be structured later if needed)
	  field :phone_number, String, null: true
	  field :image_url, String, null: true, description: "URL for the restaurant's primary image"
	  field :minimum_order_amount, Float, null: true, description: "Minimum order value for delivery" 
	  field :delivery_fee, Float, null: true, description: "Delivery fee charged by the restaurant" 
	  field :rating, Float, null: true, description: "Average user rating"
  
	  # Timestamps if needed
	  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
	  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  
	  # Field for Saved Status
	  field :is_saved_by_current_user, Boolean, null: false, description: "Indicates if the current logged-in user has saved this restaurant."
  
	  # Resolver for the saved status field
	  def is_saved_by_current_user
		current_user = context[:current_user]

		# If no user is logged in, restaurant isn't saved
		return false unless current_user
  
		# Check if a SavedRestaurant record exists for this user and this restaurant (object).
		current_user.saved_restaurants.exists?(restaurant_id: object.id)
	  end
  
	end
  end