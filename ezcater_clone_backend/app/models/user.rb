class User < ApplicationRecord
	include Devise::JWT::RevocationStrategies::JTIMatcher

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :validatable,
			:jwt_authenticatable, jwt_revocation_strategy: self
	
	validates :first_name, presence: true
	
	def jwt_payload
		super
	end
	
	has_many :addresses, dependent: :destroy
	has_many :saved_restaurants, dependent: :destroy
	has_many :restaurants, through: :saved_restaurants

	# Prevent user deletion if they have orders? Or use :destroy? Decision depends on business logic.
	# has_many :orders, dependent: :restrict_with_error

	before_save :log_jti_change_attempt, if: :jti_changed?

	private # Or keep it public if you prefer, doesn't matter much here

	def log_jti_change_attempt
	Rails.logger.info "------ JTI Change Attempt ------"
	Rails.logger.info "User ID: #{self.id}"
	# Use _was suffix for ActiveModel::Dirty attribute tracking
	Rails.logger.info "JTI Was: #{self.jti_was}"
	Rails.logger.info "JTI Is Now: #{self.jti}"
	Rails.logger.info "------------------------------"
	end
	
end
