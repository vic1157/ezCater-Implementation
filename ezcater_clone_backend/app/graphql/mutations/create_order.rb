# app/graphql/mutations/create_order.rb

module Mutations
	class CreateOrder < BaseMutation
	  description "Creates a new order for the current user with specified items."
	
	  # Input
	  argument :input, Types::Inputs::OrderCreationInputType, required: true
  
	  # Define return fields
	  field :order, Types::OrderType, null: true
	  field :errors, [Types::UserErrorType], null: false
  
	  # Resolver
	  def resolve(input:)
		current_user = context[:current_user]
		input_hash = input.to_h # hash representation
		
		# Auth Check
		unless current_user
		  return { order: nil, errors: [{ message: "Authentication required" }] }
		end
  
		# Validate Inputs
		restaurant = ::Restaurant.find_by(id: input_hash[:restaurant_id])
		unless restaurant
		  return { order: nil, errors: [{ message: "Restaurant not found", path: ['input', 'restaurantId'] }] }
		end
  
		address = current_user.addresses.find_by(id: input_hash[:address_id])
		unless address
		  return { order: nil, errors: [{ message: "Address not found or not owned by user", path: ['input', 'addressId'] }] }
		end
  
		if input_hash[:items].blank?
		  return { order: nil, errors: [{ message: "Order must contain at least one item", path: ['input', 'items'] }] }
		end
  
		# Calculate Transaction
		new_order = nil
		errors = []
  
		ActiveRecord::Base.transaction do
		  # Calculate Totals on server
		  subtotal = input_hash[:items].sum { |item| (item[:quantity] || 0) * (item[:unit_price] || 0) }
  
		  # Fetch delivery_fee, calculate tax based on location/items
		  delivery_fee = restaurant.delivery_fee || 0
		  tax_rate = 0.07 # Should be configurable based on location
		  tax_amount = subtotal * tax_rate
		  total_amount = subtotal + delivery_fee + tax_amount
		  
		  # Create Order Record
		  new_order = current_user.orders.build(
			restaurant: restaurant,
			address: address,
			delivery_at: input_hash[:delivery_at],
			headcount: input_hash[:headcount],
			special_instructions: input_hash[:special_instructions],
			status: 'pending', # Initial status
			# Calculated values:
			subtotal: subtotal,
			delivery_fee: delivery_fee,
			tax_amount: tax_amount,
			total_amount: total_amount
		  )
  
		  unless new_order.save
			# Collect errors from Order model validation
			errors = new_order.errors.map { |err| 
			  { message: err.full_message, path: ['input', err.attribute.to_s.camelize(:lower)] } 
			}
			raise ActiveRecord::Rollback # Abort transaction
		  end
  
		  # Create OrderItem Records
		  input_hash[:items].each_with_index do |item_input, index|
			item_total = (item_input[:quantity] || 0) * (item_input[:unit_price] || 0)
			order_item = new_order.order_items.build(
			  product_name: item_input[:product_name], # Use product_id lookup in production
			  quantity: item_input[:quantity],
			  unit_price: item_input[:unit_price],    # Use server-side price in production
			  total_price: item_total
			)
  
			unless order_item.save
			  item_errors = order_item.errors.map { |err| 
				{ message: err.full_message, path: ['input', 'items', index, err.attribute.to_s.camelize(:lower)] } 
			  }
			  errors.concat(item_errors)
			  raise ActiveRecord::Rollback
			end
		  end
		end
  
		# Return Result
		if errors.empty? && new_order&.persisted?
			loaded_order = Order.includes(:user, :restaurant, :address, :order_items)
			.find(new_order.id)
		  { order: loaded_order, errors: [] }
		else
		  # Return collected errors from failed transaction
		  { order: nil, errors: errors }
		end
  
	  rescue ActiveRecord::Rollback
		# Transaction failed, errors should already be populated
		{ order: nil, errors: errors }
	  rescue => e
		# Handle unexpected errors outside the transaction logic
		Rails.logger.error "CreateOrder Error: #{e.message}\n#{e.backtrace.join("\n")}"
		{ order: nil, errors: [{ message: "An unexpected server error occurred." }] }
	  end
	end
  end