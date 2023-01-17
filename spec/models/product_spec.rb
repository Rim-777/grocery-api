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
require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'associates product with carts_products' do
    should have_many(:carts_products)
      .class_name(CartsProduct.name)
      .inverse_of(:product)
      .dependent(:destroy)
  end

  it 'associates product with products' do
    should have_many(:carts).through(:carts_products)
  end

  it 'associates product with products_actions' do
    should have_many(:products_actions)
      .class_name(ProductsAction.name)
      .inverse_of(:product)
      .dependent(:destroy)
  end

  it 'associates product with actions' do
    should have_many(:actions).through(:products_actions)
  end
end
