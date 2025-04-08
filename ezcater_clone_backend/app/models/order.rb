class Order < ApplicationRecord
	belongs_to :user
	belongs_to :restaurant
	belongs_to :address

  	validates :delivery_at, presence: true
	validates :headcount, presence: true, numericality: { only_integer: true, greater_than: 0 }
	validates :status, presence: true
	validates :status, inclusion: { in %w[pending confirmed preparing delivered cancelled], message: "%w{value} is not a valid status" }

	has_many :order_items, dependent: :destroy # If order is deleted, delete its items
end
