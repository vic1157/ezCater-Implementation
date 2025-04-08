# app/graphql/mutations/save_restaurant.rb

module Mutations
	class SaveRestaurant < BaseMutation
	  description "Saves a restaurant to the current user's list of saved restaurants."
  
	  # Args
	  argument :restaurant_id, ID, required: true, description: "The ID of the restaurant to save."
  
	  # Return Type
	  field :restaurant, Types::RestaurantType, null: true, description: "The restaurant that was saved."
	  field :errors, [Types::UserErrorType], null: true, description: "Errors encountered, if any."
  
	  # Resolver
	  def resolve(restaurant_id:)
		current_user = context[:current_user]
  
		# 1. Authentication Check
		unless current_user
		  return { restaurant: nil, errors: [ { message: "Authentication required", path: ['restaurantId'] } ] }
		end
  
		# 2. Find the Restaurant
		restaurant = ::Restaurant.find_by(id: restaurant_id) 
		unless restaurant
		  return { restaurant: nil, errors: [ { message: "Restaurant not found", path: ['restaurantId'] } ] }
		end
  
		# 3. Attempt to Save (create association)
  
		# Check if already saved to provide a specific message or just succeed silently
		if current_user.saved_restaurants.exists?(restaurant_id: restaurant.id)
		   # Already saved, return success without doing anything
		   return { restaurant: restaurant, errors: [ { message: "Restaurant already saved", path: ['restaurantId'] } ] }
		end
  
		# Create the join record explicitly
		saved_link = current_user.saved_restaurants.build(restaurant: restaurant)
  
		if saved_link.save
		  # Success: Return the restaurant
		  {
			restaurant: restaurant, # The association was successful
			errors: []
		  }
		else
		  errors = saved_link.errors.map do |error|
			 { message: error.full_message, path: ['restaurantId'] } 
		  end
		  { restaurant: nil, errors: errors }
		end
  
	  rescue ActiveRecord::RecordNotFound
		 { restaurant: nil, errors: [ { message: "Restaurant not found", path: ['restaurantId'] } ] }
	  rescue => e
		Rails.logger.error "SaveRestaurant Error: #{e.message}\n#{e.backtrace.join("\n")}"
		{ restaurant: nil, errors: [ { message: "An unexpected error occurred.", path: ['restaurantId'] } ]}
	  end
	end
  end