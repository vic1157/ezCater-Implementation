# app/graphql/mutations/user_logout.rb

# Defines the mutation for logging out a user.
module Mutations
	# Inherits from BaseMutation which provides context and base functionality.
	class UserLogout < BaseMutation
	  description "Logs out the currently authenticated user by invalidating their token"
	  
	  # Define the payload type
	  # Using GraphQL fields to specify the structure of the response
	  field :user, Types::UserType, null: true, description: "The user that was logged out"
	  field :success, Boolean, null: false, description: "True if the logout was successful"
	  field :message, String, null: false, description: "A message confirming logout status"
	  
	  def resolve
		current_user = context[:current_user]
		warden = context[:warden]
	  
		unless current_user && warden
		  raise GraphQL::ExecutionError, "Authentication required: You must be logged in to perform this action."
		end
  
		# Attempt standard logout first (might still clear Warden state)
		warden.logout(scope: :user)
		Rails.logger.info "Warden logout called for User ##{current_user.id}" # Use current_user here
  
		new_jti = SecureRandom.uuid # Generate a new unique ID
  
		begin
		  # Use update! on the current_user directly
		  current_user.update!(jti: new_jti) 
		  Rails.logger.info "Manually updated JTI for User ##{current_user.id} to: #{current_user.jti}"
  
		rescue ActiveRecord::RecordInvalid => e
		  Rails.logger.error("UserLogout Mutation Error - JTI Save failed: #{e.message}")
		  # Re-raise as a GraphQL error so the client knows
		  raise GraphQL::ExecutionError, "Logout failed during token invalidation: #{e.message}" 
		end
		
		# Return success payload with user data from before logout
		{
		  success: true,
		  message: "You have been successfully logged out.",
		  user: current_user  # Fixed this from 'user' to 'current_user'
		}
	  end
	end
  end