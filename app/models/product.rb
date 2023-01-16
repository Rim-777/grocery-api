# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  currency   :string(3)        not null
#  name       :string           not null
#  price      :decimal(21, 12)  not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_products_on_code  (code) UNIQUE
#
class Product < ApplicationRecord
  has_many :carts_products,
           class_name: CartsProduct.name,
           inverse_of: :product,
           dependent: :destroy

  has_many :carts, through: :carts_products

  has_many :products_actions,
           class_name: ProductsAction.name,
           inverse_of: :product,
           dependent: :destroy

  has_many :actions, through: :products_actions

  validates :code, :name, presence: true
  validates :code, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  money_column :price, currency_column: :currency
end
