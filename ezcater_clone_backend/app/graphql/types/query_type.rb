# frozen_string_literal: true

module Types
	class QueryType < Types::BaseObject
		description "The root query type"
		
		field :current_user, Types::UserType, null: true, description: "The currently logged-in user, if any."
		
		def current_user
			# 1
			# Rails.logger.info "GraphQL Context: #{context.inspect}"
			context[:current_user]
		end

		# Address Query
		field :my_addresses, [Types::AddressType], null: false, description: "Retrieves the list of addresses saved by the current user."
		
		# Resolver method for my_addresses
		def my_addresses # Arguments hash would be passed here if defined above
			current_user = context[:current_user]
			
			# Ensure user is logged in
			unless current_user
				# Return empty array for unauthenticated users for this query
				# Alternatively, raise GraphQL::ExecutionError.new("Authentication required")
				raise GraphQL::ExecutionError.new("Authentication required", extensions: { code: 'AUTHENTICATION_ERROR' })
			end
		
		current_user.addresses.order(created_at: :desc)
		end
		
		# Saved Restaurants Query
		field :my_saved_restaurants, [Types::RestaurantType], null: false, description: "Retrieves the list of restaurants saved by the current user." 
	  
		  # Resolver method for my_saved_restaurants
		  def my_saved_restaurants
			current_user = context[:current_user]
	  
			# 1. Authentication Check
			unless current_user
			  raise GraphQL::ExecutionError.new("Authentication required")
			end
	  
			# 2. Fetch Saved Restaurants
			current_user.restaurants.order(:name)
		  end
		
		# Orders Query
		field :my_orders, [Types::OrderType], null: false, description: "Retrieves the list of orders placed by the current user." do
			# Arguments for filtering and pagination
			argument :status, String, required: false, description: "Filter orders by status (e.g., 'confirmed', 'delivered')."
			argument :limit, Integer, required: false, default_value: 20, description: "Number of orders per page."
			argument :offset, Integer, required: false, default_value: 0, description: "Offset for pagination."
			argument :order_by, String, required: false, default_value: "delivery_at DESC", description: "Column to order by (e.g., 'delivery_at DESC', 'created_at ASC')."
		  end

		# Resolver method for my_orders
		def my_orders(status: nil, limit:, offset:, order_by:)
			current_user = context[:current_user]

			# 1. Authentication Check
			unless current_user
				raise GraphQL::ExecutionError.new("Authentication required")
			end

			# 2. Scope (orders, relative to user)
			scope = current_user.orders

			# 3. Apply Filters
			scope = scope.where(status: status) if status.present?

			# 4. Define allowed columns and map the input string safely
			allowed_sort_columns = {
				"delivery_at" => :delivery_at,
				"created_at" => :created_at,
				"total_amount" => :total_amount,
				"status" => :status
			  }
			
			sort_column_key = :delivery_at # Default column
			sort_direction = :desc      # Default direction

			if order_by.present?
				col_name, dir_name = order_by.split
				col_name&.downcase!
				dir_name&.upcase!

				if allowed_sort_columns.key?(col_name)
					sort_column_key = allowed_sort_columns[col_name]
				  end
				  if ['ASC', 'DESC'].include?(dir_name)
					sort_direction = dir_name.downcase.to_sym
				  end
				end
				# Apply the safe ordering
				scope = scope.order(sort_column_key => sort_direction)

				# 5. Apply Pagination
				scope = scope.limit(limit).offset(offset)

				# 6. Preload the data needed by the OrderType resolvers
				scope.includes(:user, :restaurant, :address, :order_items)
			end

		# Single Order Query
		field :order, Types::OrderType, null: true, description: "Finds a single order by its ID." do
			argument :id, ID, required: true, description: "The ID of the order to retrieve."
		end
	  
		  # Resolver method for order
		  def order(id:)
			current_user = context[:current_user]
	  
			# 1 Auth Check
			unless current_user
			  raise GraphQL::ExecutionError.new("Authentication required", extensions: { code: 'AUTHENTICATION_ERROR' })
			end
	  
			# 2 Find the Order and Eager Load Associations
			order = ::Order.includes(:user, :restaurant, :address, :order_items).find_by(id: id)
	  
			# 3 Check if order is found
			unless order
			  return nil
			end
	  
			# 4 Authorization Check
			unless order.user_id == current_user.id
			  # Raise an auth error 
			  raise GraphQL::ExecutionError.new("You are not authorized to view this order", extensions: { code: 'AUTHORIZATION_ERROR' })
			end
	  
			# 5
			order
		  end

		field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
		argument :id, ID, required: true, description: "ID of the object."
		end

		def node(id:)
		context.schema.object_from_id(id, context)
		end

		field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
		argument :ids, [ID], required: true, description: "IDs of the objects."
		end

		def nodes(ids:)
		ids.map { |id| context.schema.object_from_id(id, context) }
		end

		# Add root-level fields here.
		# They will be entry points for queries on your schema.
	end
end
