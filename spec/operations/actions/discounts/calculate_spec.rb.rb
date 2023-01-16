# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::Discounts::Calculate do
  subject { described_class }

  def operation
    subject.call(options)
  end

  def operation_result
    operation.result
  end

  describe '#call' do
    let!(:strawberries) do
      create(
        :product,
        code: 'SR1',
        name: 'Strawberries',
        price: Money.new(5.0)
      )
    end

    let(:options) do
      {
        product: strawberries,
        quantity: 3
      }
    end

    shared_examples :action_is_not_applied do
      it 'does not apply discount' do
        expect(operation_result.applied).to be(false)
      end

      it 'returns unchanged price' do
        expect(operation_result.price.to_f).to eq(strawberries.price)
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
          expect(operation_result.applied).to be(true)
        end

        it 'returns an expected bonus price' do
          expect(operation_result.price.to_f).to eq(4.5)
        end
      end

      context 'insufficient quantity for actions' do
        before do
          options[:quantity] = 2
        end

        include_examples :action_is_not_applied
      end
    end

    context 'action is not present' do
      include_examples :action_is_not_applied
    end
  end
end
