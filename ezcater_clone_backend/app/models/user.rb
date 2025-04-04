class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :validatable
	
	has_many :addresses, dependent: :destroy
	has_many :saved_restaurants, dependent: :destroy
	has_many :restaurants, through: :saved_restaurants

	# Prevent user deletion if they have orders? Or use :destroy? Decision depends on business logic.
	# has_many :orders, dependent: :restrict_with_error
	
end
