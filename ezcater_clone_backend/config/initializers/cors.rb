# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
	allow do
	# Be speciifc with your frontend origin(s)
	# Adjust port if your Next.js runs elsewhere
	origins 'http://localhost:3000'
	
	# Only allow requests to the /graphql endpoint
	resource '/graphql',
	# Allow necessary headers like Authorization, Content-Type etc.
	headers: :any,
	# GraphQL primarily uses POST, but allow others for preflight etc
	methods: [:get, :post, :options, :head],

	# Expose headers might be needed depending on JWT strategy (check devise-jwt docs)
	# These are examples, adjust if needed
	expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
	end
end