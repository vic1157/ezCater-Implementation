# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
	description "The mutation root of this schema"

    field :user_login, mutation: Mutations::UserLogin, description: "Logs in a user"
    
  end
end
