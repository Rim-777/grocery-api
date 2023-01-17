# frozen_string_literal: true

# == Schema Information
#
# Table name: actions
#
#  id             :bigint           not null, primary key
#  bonus_quantity :integer          default(0), not null
#  coefficient    :decimal(12, 10)  default(1.0), not null
#  min_quantity   :integer          not null
#  type           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_actions_on_type  (type)
#
require 'rails_helper'

RSpec.describe Action::Bonus, type: :model do
  it { should validate_numericality_of(:bonus_quantity).is_greater_than_or_equal_to(0) }
end
