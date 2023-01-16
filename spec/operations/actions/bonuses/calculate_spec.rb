# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::Bonuses::Calculate do
  subject { described_class }

  def operation
    subject.call(options)
  end

  def operation_result
    operation.result
  end

  describe '#call' do
    let!(:green_tea) do
      create(
        :product,
        code: 'GR1',
        name: 'Green Tea',
        price: Money.new(3.11)
      )
    end

    let(:options) do
      {
        product: green_tea,
        quantity: 2
      }
    end

    context 'action is present' do
      let(:action_bonus) { create(:action_bonus, bonus_quantity: 1, min_quantity: 0) }

      before do
        green_tea.actions = [action_bonus]
      end

      it 'approves the bonus' do
        expect(operation_result.applied).to be(true)
      end

      it 'returns an expected bonus quantity' do
        expect(operation_result.quantity).to eq(2)
      end

      it 'returns an expected bonus price' do
        expect(operation_result.price).to be_zero
      end
    end

    context 'action is not present' do
      it 'does not approve the bonus' do
        expect(operation_result.applied).to be(false)
      end

      it 'returns an expected bonus quantity' do
        expect(operation_result.quantity).to eq(0)
      end
    end
  end
end
