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
