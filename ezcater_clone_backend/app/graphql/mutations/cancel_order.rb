# app/graphql/mutations/cancel_order.rb
module Mutations
	class CancelOrder < BaseMutation
	  description "Cancels an order belonging to the current user."
  
	  argument :id, ID, required: true, description: "The ID of the order to cancel."
  
	  field :order, Types::OrderType, null: true, description: "The order that was cancelled."
	  field :errors, [Types::UserErrorType], null: true, description: "Errors encountered, if any."
  
	  def resolve(id:)
		current_user = context[:current_user]
  
		# 1 Auth Check
		unless current_user
		  return { order: nil, errors: [ { message: "Authentication required", path: ['id'] } ] }
		end
  
		# 2 Find Order 
		order = current_user.orders.includes(:user, :restaurant, :address, :order_items).find_by(id: id)
  
		unless order
		  return { order: nil, errors: [ { message: "Order not found or not owned by user", path: ['id'] } ] }
		end
  
		# 3 Biz Logic to cancel
		allowed_statuses_for_cancel = ['pending', 'confirmed']
		unless allowed_statuses_for_cancel.include?(order.status)
		   return { order: nil, errors: [ { message: "Order cannot be cancelled in its current status (#{order.status})", path: ['id'] } ] }
		end
  
		# 4 Update Status
		if order.update(status: 'cancelled')
		  # Success: Return the updated order
		  {
			order: order,
			errors: []
		  }
		else
		  errors = order.errors.map { |err| { message: err.full_message, path: ['id'] } }
		  { order: nil, errors: errors.presence || [{ message: "Failed to cancel order.", path: ['id'] }] }
		end
  
	  rescue ActiveRecord::RecordNotFound
		 { order: nil, errors: [ { message: "Order not found", path: ['id'] } ] }
	  rescue => e
		Rails.logger.error "CancelOrder Error: #{e.message}\n#{e.backtrace.join("\n")}"
		{ order: nil, errors: [ { message: "An unexpected error occurred.", path: ['id'] } ]}
	  end
	end
  end