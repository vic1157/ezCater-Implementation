# app/graphql/types/address_type.rb
module Types
	class AddressType < Types::BaseObject
		description "Represents a delivery address"

		field :id, ID, null: false
		field :nickname, String, null: true, description: "A user-given nickname for the address (e.g., 'Home', 'Office')"
		field :street_address, String, null: false, description: "Street name and number, floor, suite, etc."
		field :city, String, null: false
		field :state, String, null: false, description: "State or province abbreviation (e.g., 'MA')"
		field :zip_code, String, null: false, description: "Postal code"
		field :is_default, Boolean, null: true 
		field :last_used_at, GraphQL::Types::ISO8601DateTime, null: true # May be useful for 'Recent Addresses' sorting
		
		# Expose timestamps if needed by the frontend
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
		end
	end