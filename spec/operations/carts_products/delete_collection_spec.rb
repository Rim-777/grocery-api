# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsProducts::DeleteCollection do
  def operation
    described_class.call(payload)
  end

  describe '#call' do
    let(:payload) { { attributes: { id: :some_id } } }

    it 'makes a db request' do
      expect(CartsProduct).to receive(:where).with(payload.fetch(:attributes)).and_call_original
      operation
    end

    it 'receives delete_all method' do
      carts_products_ar_relation = double(delete_all: 3)
      allow(CartsProduct).to receive(:where).and_return(carts_products_ar_relation)
      expect(carts_products_ar_relation).to receive(:delete_all)
      operation
    end
  end
end
