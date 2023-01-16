# frozen_string_literal: true

# == Schema Information
#
# Table name: carts_products
#
#  id         :bigint           not null, primary key
#  bonus      :boolean          default(FALSE), not null
#  currency   :string(3)        not null
#  price      :decimal(21, 12)  not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cart_id    :integer
#  product_id :integer
#
# Indexes
#
#  index_carts_products_on_cart_id_and_product_id_and_bonus  (cart_id,product_id,bonus)
#
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
