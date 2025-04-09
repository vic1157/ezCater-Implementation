# frozen_string_literal: true
# app/graphql/types/mutation_type.rb


module Types
  class MutationType < Types::BaseObject
	description "The mutation root of this schema"

	# Authentication
    field :user_login, mutation: Mutations::UserLogin, description: "Logs in a user"
    field :user_logout, mutation: Mutations::UserLogout, description: "Logs the current user out"
    
    # Addresses
    field :create_address, mutation: Mutations::CreateAddress, description: "Creates a new address for the current user"
    field :update_address, mutation: Mutations::UpdateAddress, description: "Updates an existing address for the current user"
    field :delete_address, mutation: Mutations::DeleteAddress, description: "Deletes an existing address for the current user"

    # Restaurants
    field :save_restaurant, mutation: Mutations::SaveRestaurant, description: "Adds a restaurant to the user's saved list"
    field :unsave_restaurant, mutation: Mutations::UnsaveRestaurant, description: "Removes a restaurant from the user's saved list"

	# Orders
	field :create_order, mutation: Mutations::CreateOrder, description: "Creates a new order"

  end
end
