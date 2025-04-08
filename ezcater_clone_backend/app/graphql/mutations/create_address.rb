# app/graphql/mutations/create_address.rb
module Mutations
	class CreateAddress < BaseMutation
		description "Creates a new address for the current user."
	  
		# Input
		argument :input, Types::Inputs::AddressInputType, required: true
		
		# Return
		# Define what the mutation returns on success
		field :address, Types::AddressType, null: true, description: "The newly created address."
		# Define a field for potential validation errors
		field :errors, [Types::UserErrorType], null: true, description: "Errors encountered during address creation."
		
		# Resolver
		def resolve(input:)
			current_user = context[:current_user]
			
			# Auth Check
			unless current_user
				raise GraphQL::ExecutionError.new("Authentication required", extensions: { code: 'AUTHENTICATION_ERROR' })
			end
		
			# Build the Address - make it affiliated with currentUser
			address = current_user.addresses.build(input.to_h)
			
			if address.save
				{
				address: address,
				errors: []
				}
				else
					# Failure: Map ActiveRecord validation errors to our GraphQL error type
				errors = address.errors.map do |error|
					{
						path: ['input', error.attribute.to_s.camelize(:lower)], # e.g., ['input', 'streetAddress']
						message: error.message
					}
				end

				{
					address: nil,
					errors: errors
				}
			end
		
		rescue => e
			Rails.logger.error "CreateAddress Error: #{e.message}\n#{e.backtrace.join("\n")}"
			raise GraphQL::ExecutionError, "An unexpected error occurred."
		end
	end
end
	 