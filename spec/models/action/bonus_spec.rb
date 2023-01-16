# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action::Bonus, type: :model do
  it { should validate_numericality_of(:bonus_quantity).is_greater_than_or_equal_to(0) }
end
