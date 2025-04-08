# app/graphql/mutations/user_login.rb
module Mutations
	class UserLogin < BaseMutation
		description "Logs a user in by email and password, returning a JWT token."
  
		# Argument remains the same
		# argument :input, Types::Inputs::UserLoginInputType, required: true
		argument :email, String, required: true, description: "User's email address"
    	argument :password, String, required: true, description: "User's password"
		
		# Define the return fields DIRECTLY on the mutation
		field :token, String, null: true, description: "JWT authentication token"
		field :user, Types::UserType, null: true, description: "Logged in user information"
		
	
		def resolve(email:, password:)
			user = User.find_by('lower(email) = ?', email.downcase) # Use input[:email]
	
			unless user&.valid_password?(password) # Use input[:password]
				raise GraphQL::ExecutionError, "Invalid email or password"
			end
	
			unless context[:warden]
				raise GraphQL::ExecutionError, "Internal Server Error: Warden context not available"
			end
	
			context[:warden].set_user(user, scope: :user)
	
			encoder = Warden::JWTAuth::UserEncoder.new
			token, _payload = encoder.call(user, :user, nil)
	
			# ---- CHANGE HERE ----
			# Return a hash matching the fields defined above (no nesting)
			{
			token: token,
			user: user
			}
			# ---- END CHANGE ----
	
		# Keep rescue blocks as they are fine
		rescue ActiveRecord::RecordNotFound => e
			raise GraphQL::ExecutionError, "Invalid email or password"
		rescue => e
			Rails.logger.error("UserLogin Mutation Error: #{e.message}")
			Rails.logger.error(e.backtrace.join("\n"))
			raise GraphQL::ExecutionError, "An unexpected error occured during login."
		end
	end
end