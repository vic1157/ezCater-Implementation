# app/graphql/types/user_type.rb

module Types
	class UserType < Types::BaseObject
		description "A user of the application"
		
		field :id, ID, null:false
		field :email, String, null: false
		field :first_name, String, null: true
		field :last_name, String, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
end 	
