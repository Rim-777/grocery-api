# frozen_string_literal: true

class Action
  class Discount < Action
    validates :min_quantity, numericality: { greater_than_or_equal_to: 0 }
    validates :coefficient, numericality: true
  end
end
