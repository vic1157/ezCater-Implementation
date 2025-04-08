# app/graphql/types/order_type.rb

module Types
	class OrderType < Types::BaseObject
	  description "Represents a catering order"
  
	  field :id, ID, null: false
	  field :delivery_at, GraphQL::Types::ISO8601DateTime, null: false, description: "Requested delivery date and time"
	  field :headcount, Integer, null: false, description: "Number of people the order is for"
	  field :status, String, null: false, description: "Current status of the order (e.g., pending, confirmed, delivered)"
	  field :subtotal, Float, null: true 
	  field :delivery_fee, Float, null: true 
	  field :tax_amount, Float, null: true 
	  field :total_amount, Float, null: true 
	  field :special_instructions, String, null: true

	  # Associations
	  field :user, Types::UserType, null: false, description: "The user who placed the order."
	  field :restaurant, Types::RestaurantType, null: false, description: "The restaurant fulfilling the order."
	  field :address, Types::AddressType, null: false, description: "The delivery address for the order."
	  field :order_items, [Types::OrderItemType], null: false, description: "List of items included in the order."

	  # Timestamps
	  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
	  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

	  # Association Resolvers
	  def user
		object.user 
	  end

	  def restaurant
		object.restaurant 
	  end

	  def address
		object.address
	  end
  
	  def order_items
		object.order_items 
	  end
	end
end