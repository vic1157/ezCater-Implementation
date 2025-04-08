# app/graphql/mutations/unsave_restaurant.rb
module Mutations
	class UnsaveRestaurant < BaseMutation
	  description "Removes a restaurant from the current user's list of saved restaurants."
  
	  # Arguments
	  argument :restaurant_id, ID, required: true, description: "The ID of the restaurant to unsave."
  
	  # Return the Restaurant so client can update its status
	  field :restaurant, Types::RestaurantType, null: true, description: "The restaurant that was unsaved."
	  field :errors, [Types::UserErrorType], null: true, description: "Errors encountered, if any."
  
	  # Resolver
	  def resolve(restaurant_id:)
		current_user = context[:current_user]
  
		# 1. Authentication Check
		unless current_user
		  return { restaurant: nil, errors: [ { message: "Authentication required", path: ['restaurantId'] } ] }
		end
  
		# 2. Find the Restaurant (to return later)
		restaurant = ::Restaurant.find_by(id: restaurant_id)
		unless restaurant
		  # If the restaurant doesn't even exist, the user can't have it saved.
		  return { restaurant: nil, errors: [ { message: "Restaurant not found", path: ['restaurantId'] } ] }
		end
  
		# 3. Find the *SavedRestaurant* Link (the join record)
		saved_link = current_user.saved_restaurants.find_by(restaurant_id: restaurant.id)
  
		# 4. Check if it was actually saved
		unless saved_link
		  # If the link doesn't exist, it's already unsaved. Return success.
		   return { restaurant: restaurant, errors: [ { message: "Restaurant was not saved by user", path: ['restaurantId'] } ] }
		end
  
		# 5. Attempt to Destroy the Link
		if saved_link.destroy
		  # Note: The 'is_saved_by_current_user' field on this returned restaurant
		  {
			restaurant: restaurant,
			errors: []
		  }
		else
		  # Failure (e.g., destroy callbacks fail)
		  errors = saved_link.errors.map do |error|
			 { message: error.full_message, path: ['restaurantId'] }
		  end
		  { restaurant: nil, errors: errors.presence || [{ message: "Failed to unsave restaurant.", path: ['restaurantId'] }] }
		end
  
	  rescue ActiveRecord::RecordNotFound # Should be caught by initial restaurant find_by
		 { restaurant: nil, errors: [ { message: "Restaurant not found", path: ['restaurantId'] } ] }
	  rescue => e
		Rails.logger.error "UnsaveRestaurant Error: #{e.message}\n#{e.backtrace.join("\n")}"
		{ restaurant: nil, errors: [ { message: "An unexpected error occurred.", path: ['restaurantId'] } ]}
	  end
	end
  end