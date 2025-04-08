# app/graphql/types/order_item_type.rb

module Types
	class OrderItemType < Types::BaseObject
	  description "Represents a single line item within an order"
  
	  field :id, ID, null: false
	  field :product_name, String, null: false, description: "Name of the product ordered"
	  field :quantity, Integer, null: false
	  field :unit_price, Float, null: false, description: "Price per unit" # Use Float for GraphQL decimal
	  field :total_price, Float, null: false, description: "Total price for this line item (quantity * unit_price)"
  
  
	  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
	  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
  end