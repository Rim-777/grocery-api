# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::Discounts::Calculate do
  def operation
    described_class.call(payload)
  end

  def operation_result
    operation.result
  end

  describe '#call' do
    let!(:strawberries) do
      create(:product, code: 'SR1', name: 'Strawberries', price: Money.new(5.0))
    end

    let(:payload) do
      {
        product: strawberries,
        quantity: 3
      }
    end

    shared_examples :action_is_not_applied do
      it 'does not apply discount' do
        expect(operation_result).not_to be_aplied
      end

      it 'returns unchanged price' do
        expect(operation_result.price).to eq(strawberries.price)
      end
    end

    context 'action is present' do
      let(:action_discount) do
        create(:action_discount, coefficient: 0.90, min_quantity: 3)
      end

      before do
        strawberries.actions = [action_discount]
      end

      context 'sufficient quantity for actions' do
        it 'approves discount' do
          expect(operation_result).to be_applied
        end

        it 'returns an expected bonus price' do
          expect(operation_result.price).to eq(Money.new(4.5))
        end
      end

      context 'insufficient quantity for actions' do
        before do
          payload[:quantity] = 2
        end

        include_examples :action_is_not_applied
      end
    end

    context 'action is not present' do
      include_examples :action_is_not_applied
    end
  end
end
