# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action::Discount, type: :model do
  it { should validate_numericality_of(:min_quantity).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:coefficient) }
end
