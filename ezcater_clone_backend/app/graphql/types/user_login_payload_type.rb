# app/graphql/types/user_login_payload_type.rb

module Types
	class UserLoginPayloadType < Types::BaseObject
		description "Return type for successful user login"
		
		field :token, String, null: true, description: "JWT authentication token for subsequent requests"
		# 1
		field :user, Types::UserType, null: true, description: "Information about the logged in user"
	end
end