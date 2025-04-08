# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
	description "The mutation root of this schema"

    field :user_login, mutation: Mutations::UserLogin, description: "Logs in a user"
	field :user_logout, mutation: Mutations::UserLogout, description: "Logs the current user out"
    
    
  end
end
