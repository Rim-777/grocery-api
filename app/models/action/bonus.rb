# frozen_string_literal: true

class Action
  class Bonus < Action
    validates :bonus_quantity, numericality: { greater_than_or_equal_to: 0 }
  end
end
