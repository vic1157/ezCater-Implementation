class OrderItem < ApplicationRecord
  belongs_to :order

  validates :product_name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_total_price

  def calculate_total_price
    # Check if both quantity and unit_price are present and numeric to avoid errors
    if quantity.present? && quantity.is_a?(Numeric) && unit_price.present? && unit_price.is_a?(Numeric)
      # Calculate and assign the total price
      self.total_price = quantity * unit_price
    end
  end
end
