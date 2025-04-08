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
    
  end
end
