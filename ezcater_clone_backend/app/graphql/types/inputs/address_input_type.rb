module Types
	module Inputs
		class AddressInputType < Types::BaseInputObject
			description "Attributes for creating or updating an address"
	
			argument :nickname, String, required: false, description: "Optional user-given nickname"
			argument :street_address, String, required: true, description: "Street name and number, floor, suite, etc."
			argument :city, String, required: true
			argument :state, String, required: true, description: "State or province abbreviation (e.g., 'MA')"
			argument :zip_code, String, required: true, description: "Postal code"
		
	  	end
	end
end