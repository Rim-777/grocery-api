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
class Action
  class Discount < Action
    validates :min_quantity, numericality: { greater_than_or_equal_to: 0 }
    validates :coefficient, numericality: true
  end
end
