# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsProducts::DeleteBonusItems do
  def operation
    described_class.call(payload)
  end

  describe '#call' do
    let!(:cart) { create(:cart) }

    let!(:product) do
      create(:product, code: 'GR1', name: 'Green Tea', price: Money.new(3.11))
    end

    let(:cart_id) { cart.id }
    let(:product_id) { product.id }

    let(:bonus_items) do
      list = create_list(
        :carts_product,
        3,
        price: Money.new(0),
        cart_id: cart_id,
        product_id: product_id,
        bonus: true
      )

      CartsProduct.where(id: list.map(&:id))
    end

    let(:other_cart_products) do
      list = create_list(
        :carts_product,
        3,
        price: product.price,
        cart_id: cart_id,
        product_id: product_id
      )

      CartsProduct.where(id: list.map(&:id))
    end

    let(:payload) do
      {
        cart_id: cart_id,
        product_id: product_id
      }
    end

    before do
      bonus_items
      other_cart_products
    end

    it 'deletes records from the database' do
      expect { operation }.to change(CartsProduct, :count).from(6).to(3)
    end

    it 'deletes proper records from the database' do
      expect { operation }.to change(bonus_items, :count).from(3).to(0)
    end

    it 'does not delete other records' do
      expect { operation }.not_to change(other_cart_products, :count)
    end
  end
end
