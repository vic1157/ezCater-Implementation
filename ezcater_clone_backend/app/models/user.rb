class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :validatable
	
	# Add this line. dependent: :destory deletes user's addresses if user is deleted
	has_many :addresses, dependent: :destroy

end
