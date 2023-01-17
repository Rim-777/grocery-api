# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::Bonuses::Calculate::BonusStruct do
  subject { described_class }
  let(:price_and_quantity) { { price: Money.new(100), applied: false, quantity: 3 } }
  let(:applied_bonus_struct) { subject.new(price_and_quantity.merge(applied: true)) }
  let(:not_applied_bonus_struct) { subject.new(price_and_quantity.merge(applied: false)) }

  describe '#applied?' do
    it 'returns true' do
      expect(applied_bonus_struct.applied?).to be(true)
    end

    it 'returns true' do
      expect(not_applied_bonus_struct.applied?).to be(false)
    end
  end
end
