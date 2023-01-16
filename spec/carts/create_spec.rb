# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::Create do
  subject { described_class }

  def operation
    subject.call
  end

  describe '#call' do
    it 'creates a new cart' do
      expect { operation }.to change(Cart, :count).from(0).to(1)
    end

    it 'assigns a created cart to an operation result' do
      expect(operation.result).to be_a(Cart)
    end

    it 'returns an empty cart' do
      expect(operation.result.carts_products).to be_empty
    end
  end
end
