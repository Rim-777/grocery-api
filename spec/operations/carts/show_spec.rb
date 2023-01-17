# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::Show do
  let!(:cart) { create(:cart) }
  let(:cart_id) { cart.id }

  def operation
    described_class.call(cart_id: cart_id)
  end

  describe '#call' do
    context 'success' do
      it 'returns a cart' do
        expect(operation.result).to eq(cart)
      end
    end

    context 'failure' do
      let(:cart_id) { 94_305_934_509_345 }

      it 'raises not found error' do
        expect { operation }
          .to raise_error(
            ActiveRecord::RecordNotFound,
            "Couldn't find Cart with 'id'=#{cart_id}"
          )
      end
    end
  end
end
