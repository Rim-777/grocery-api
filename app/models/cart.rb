# frozen_string_literal: true

# == Schema Information
#
# Table name: carts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Cart < ApplicationRecord
  has_many :carts_products,
           class_name: CartsProduct.name,
           inverse_of: :cart,
           dependent: :destroy

  has_many :products, through: :carts_products
end
