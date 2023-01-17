# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsProducts::ApplyDiscount do
  def operation
    described_class.call(payload)
  end

  describe '#call' do
    let!(:cart) { create(:cart) }

    let(:product_price) { Money.new(5.0) }

    let!(:product) do
      create(:product, code: 'SR1', name: 'Strawberries', price: product_price)
    end

    let!(:carts_products) do
      list = create_list(
        :carts_product, 3,
        cart_id: cart.id,
        product_id: product.id,
        price: product_price
      )

      CartsProduct.where(id: list.map(&:id))
    end

    let(:payload) do
      { carts_products: carts_products }
    end

    context 'discount is applied' do
      let(:reduced_price) { Money.new(4.5) }

      let(:discount_calculate_operation) do
        double(
          result: Actions::Discounts::Calculate::DiscountStruct.new(
            applied: true, prices: [reduced_price, reduced_price, reduced_price]
          )
        )
      end

      before do
        allow(Actions::Discounts::Calculate)
          .to receive(:call)
          .and_return(discount_calculate_operation)

        operation
      end

      it 'changes prices' do
        carts_products.each do |carts_product|
          expect(carts_product.price).to eq(reduced_price)
        end
      end
    end

    context 'discount is not applied' do
      let(:discount_calculate_operation) do
        double(
          result: Actions::Discounts::Calculate::DiscountStruct.new(
            applied: false,
            prices: [product_price, product_price, product_price]
          )
        )
      end

      before do
        allow(Actions::Discounts::Calculate)
          .to receive(:call)
          .and_return(discount_calculate_operation)
        operation
      end

      it 'does not change prices' do
        carts_products.each do |carts_product|
          expect(carts_product.price).to eq(product_price)
        end
      end
    end
  end
end
