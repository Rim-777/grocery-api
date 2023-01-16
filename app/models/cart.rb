# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :carts_products,
           class_name: CartsProduct.name,
           inverse_of: :cart,
           dependent: :destroy

  has_many :products, through: :carts_products
end
