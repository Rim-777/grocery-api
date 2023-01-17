# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsProducts::CreateCollection do
  def operation
    described_class.call(payload)
  end

  def operation_result
    operation.result
  end

  describe '#call' do
    let!(:cart) { create(:cart) }
    let(:cart_id) { cart.id }
    let(:price) { Money.new(3.11) }

    let!(:product) do
      create(:product, code: 'GR1', name: 'Green Tea', price: price)
    end

    let(:product_id) { product.id }

    let(:attributes) do
      {
        product_id: product_id,
        cart_id: cart_id,
        price: price
      }
    end

    let(:payload) do
      {
        attributes: attributes,
        quantity: 3
      }
    end

    context '#success' do
      it 'looks like success' do
        expect(operation).to be_success
      end

      it 'has no errors' do
        expect(operation.errors).to be_empty
      end

      it 'creates new records' do
        expect { operation }.to change(CartsProduct, :count).from(0).to(3)
      end

      it 'associates new records with a cart' do
        expect { operation }.to change(cart.carts_products, :count).from(0).to(3)
      end

      it 'associate new records with a product' do
        expect { operation }.to change(product.carts_products, :count).from(0).to(3)
      end

      it 'assigns a created collection to the operation result' do
        expect(operation_result).to be_a(Array)
        expect(operation_result.count).to eq(3)
      end

      it 'creates records with correct attributes' do
        operation_result.each do |carts_product|
          expect(carts_product)
            .to have_attributes(
              product_id: product_id,
              cart_id: cart_id,
              price: price,
              bonus: false
            )
        end
      end
    end

    context 'failure' do
      before do
        attributes[:price] = nil
      end

      it 'has errors' do
        expect { operation }
          .to raise_error(
            ActiveRecord::RecordInvalid,
            'Validation failed: Price is not a number'
          )
      end

      it 'does not create records' do
        expect do
          operation
        rescue StandardError
          false
        end.not_to change(CartsProduct, :count)
      end
    end
  end
end
