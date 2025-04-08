# app/graphql/types/user_error_type.rb
module Types
	# Defines a field that wraps a user error, conforming to conventions.
	class UserErrorType < Types::BaseObject
	  description "A user-readable error, typically associated with a specific input field."
  
	  field :message, String, null: false, description: "A description of the error"
	  field :path, [String], null: true, description: "Which input value this error came from"
	end
  end