# app/graphql/mutations/delete_address.rb
module Mutations
	class DeleteAddress < BaseMutation
	  description "Deletes an address belonging to the current user."
  
	  # Args
	  argument :id, ID, required: true, description: "The ID of the address to delete."
  
	  # Return Type
	  # Return the ID of the deleted object for potential cache updates on the client
	  field :deleted_id, ID, null: true, description: "The ID of the address that was deleted."
	  field :success, Boolean, null: false, description: "True if the address was successfully deleted."
	  field :errors, [Types::UserErrorType], null: true, description: "Errors encountered during address deletion."
  
	  def resolve(id:)
		current_user = context[:current_user]
  
		# 1 Authentication Check
		unless current_user
		  # Consistent error format
		  return { deleted_id: nil, success: false, errors: [ { message: "Authentication required", path: ['id'] } ] }
		end
  
		# 2. Find the Address (scoped to current user)
		address = current_user.addresses.find_by(id: id)
  
		unless address
		  return { deleted_id: nil, success: false, errors: [ { message: "Address not found or not owned by user", path: ['id'] } ] }
		end
  
		# 3. Attempt to Destroy
		if address.destroy
		  # Success: Return the ID and success status
		  {
			deleted_id: id, # Return the original ID passed in
			success: true,
			errors: []
		  }
		else
		  errors = address.errors.map do |error|
			{
			  path: ['id'], # Error relates to the object itself
			  message: error.full_message # Get the full error message
			}
		  end
		   { deleted_id: nil, success: false, errors: errors.presence || [{ message: "Failed to delete address.", path: ['id'] }] }
		end
	  rescue ActiveRecord::RecordNotFound
		 { deleted_id: nil, success: false, errors: [ { message: "Address not found", path: ['id'] } ] }
	  rescue => e
		# Handle unexpected errors
		Rails.logger.error "DeleteAddress Error: #{e.message}\n#{e.backtrace.join("\n")}"
		{ deleted_id: nil, success: false, errors: [ { message: "An unexpected error occurred.", path: ['id'] } ]}
	  end
	end
  end