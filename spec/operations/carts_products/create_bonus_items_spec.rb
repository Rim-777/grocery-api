# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsProducts::CreateBonusItems do
  def operation
    described_class.call(options)
  end

  describe '#call' do
    let!(:cart) { create(:cart) }

    let!(:product) do
      create(
        :product,
        code: 'GR1',
        name: 'Green Tea',
        price: Money.new(3.11)
      )
    end

    let!(:carts_products) do
      list = create_list(
        :carts_product, 3,
        cart_id: cart.id,
        product_id: product.id,
        price: product.price
      )

      CartsProduct.where(id: list.map(&:id))
    end

    let(:options) do
      { carts_products: carts_products }
    end

    context 'bonus is applied' do
      let(:bonus_quantity) { 2 }
      let(:carts_products_count) { carts_products.count }
      let(:expected_bonus_count) { carts_products_count + bonus_quantity }
      let(:bonuses_calculate_operation) do
        double(
          result: Actions::Bonuses::Calculate::BonusStruct.new(
            applied: true,
            quantity: bonus_quantity,
            price: Money.new(0)
          )
        )
      end

      before do
        allow(Actions::Bonuses::Calculate)
          .to receive(:call)
          .and_return(bonuses_calculate_operation)
      end

      it 'creates bonus items' do
        expect { operation }
          .to change(CartsProduct, :count)
          .from(carts_products_count)
          .to(expected_bonus_count)
      end

      it 'creates bonus items associated with a product' do
        expect { operation }
          .to change(product.carts_products, :count)
          .from(carts_products_count)
          .to(expected_bonus_count)
      end

      it 'creates bonus items associated with a cart' do
        expect { operation }
          .to change(cart.carts_products, :count)
          .from(carts_products_count)
          .to(expected_bonus_count)
      end
    end

    context 'bonus is not applied' do
      let(:bonuses_calculate_operation) do
        double(
          result: Actions::Bonuses::Calculate::BonusStruct.new(
            applied: false,
            quantity: 0,
            price: product.price
          )
        )
      end

      before do
        allow(Actions::Bonuses::Calculate)
          .to receive(:call)
          .and_return(bonuses_calculate_operation)
      end

      it 'does not create bonus items' do
        expect { operation }.not_to change(CartsProduct, :count)
      end
    end
  end
end
