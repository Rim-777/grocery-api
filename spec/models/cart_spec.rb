# frozen_string_literal: true

# == Schema Information
#
# Table name: carts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Cart, type: :model do
  it 'associates cart with carts_products' do
    should have_many(:carts_products)
      .class_name(CartsProduct.name)
      .inverse_of(:cart)
      .dependent(:destroy)
  end

  it 'associates cart with products' do
    should have_many(:products).through(:carts_products)
  end
end
