# app/graphql/types/inputs/create_order_input_type.rb

module Types
	module Inputs
		class OrderCreationInputType < Types::BaseInputObject
			description "Attributes required to create a new order"

			argument :restaurant_id, ID, required: true, description: "ID of the restaurant for the order"
			argument :address_id, ID, required: true, description: "ID of the delivery address for the order"
			argument :delivery_at, GraphQL::Types::ISO8601DateTime, required: true, description: "Requested delivery date and time"
			argument :headcount, Integer, required: true, description: "Number of people the order is for"
			argument :special_instructions, String, required: false, description: "Overall special instructions for the order"

			# Array of line items
			argument :items, [Types::Inputs::OrderItemInputType], required: true, description: "List of items to include in the order"
		end
	end
end