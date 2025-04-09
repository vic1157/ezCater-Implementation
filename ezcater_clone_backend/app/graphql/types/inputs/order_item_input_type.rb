# app/graphql/types/inputs/order_item_input_type.rb

module Types
	module Inputs
	  class OrderItemInputType < Types::BaseInputObject
		description "Attributes for a single item within a new order"
  
		# Using name to identify product (not ideal)
		argument :product_name, String, required: true, description: "Name of the product being ordered"
		argument :quantity, Integer, required: true, description: "Number of units of this product"
  
		# Assuming client passes unit_price (unless product references exist in a db)
		argument :unit_price, Float, required: true, description: "Price per unit of the product"
	  end
	end
  end