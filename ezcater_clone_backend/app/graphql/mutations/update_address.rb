# app/graphql/mutations/update_address.rb
module Mutations
	class UpdateAddress < BaseMutation
		description "Updates an existing address belonging to the current user."
	  
		# Arguments
		# ID of the address record to update
		argument :id, ID, required: true, description: "The ID of the address to update."
		argument :input, Types::Inputs::AddressInputType, required: true
		
		# Return
		field :address, Types::AddressType, null: true, description: "The updated address."
		field :errors, [Types::UserErrorType], null: true, description: "Errors encountered during address update."
			
			# -- Resolver --
		def resolve(id:, input:)
			current_user = context[:current_user]
			
			unless current_user
			return { address: nil, errors: [ { message: "Authentication required", path: ['id'] } ] }
		end
		
		# Find Address
		address = current_user.addresses.find_by(id: id)
		
		unless address
			return { address: nil, errors: [ { message: "Address not found or not owned by user", path: ['id'] } ] }
			end
			
			if address.update(input.to_h)
			# Success: Return the updated address and no errors
			{
			address: address,
			errors: []
			}
			
			else
			# Failure: Map ActiveRecord validation errors
			errors = address.errors.map do |error|
			{
				path: ['input', error.attribute.to_s.camelize(:lower)],
				message: error.message
			}
			end

			{
			address: nil,
			errors: errors
			}
		end
		
		rescue ActiveRecord::RecordNotFound # Just in case find_by fails unexpectedly
			{ address: nil, errors: [ { message: "Address not found", path: ['id'] } ] }

		rescue => e
			# Handle unexpected errors
			Rails.logger.error "UpdateAddress Error: #{e.message}\n#{e.backtrace.join("\n")}"
			{ address: nil, errors: [ { message: "An unexpected error occurred.", path: ['id'] } ]}
		end
	end
end
	    
	    