# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsProducts::FindCollection do
  def operation
    described_class.call(options)
  end

  describe '#call' do
    let!(:product) do
      create(
        :product,
        code: 'GR1',
        name: 'Green Tea',
        price: Money.new(3.11)
      )
    end

    let!(:cart_id) { create(:cart).id }
    let(:product_id) { product.id }

    let!(:cart_products) do
      list = create_list(
        :carts_product,
        3,
        price: product.price,
        cart_id: cart_id,
        product_id: product_id
      )

      CartsProduct.where(id: list.map(&:id))
    end

    let(:options) do
      {
        attributes: {
          cart_id: cart_id,
          product_id: product_id
        }
      }
    end

    it 'returns an expected collection' do
      expect(operation.result.ids).to eq(cart_products.ids)
    end
  end
end
