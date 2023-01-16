# frozen_string_literal: true

class CartsProduct < ApplicationRecord
  belongs_to :product,
             class_name: Product.name,
             inverse_of: :carts_products

  belongs_to :cart,
             class_name: Cart.name,
             inverse_of: :carts_products

  validates :price, numericality: true

  money_column :price, currency_column: :currency
end
