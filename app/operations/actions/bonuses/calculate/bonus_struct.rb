# frozen_string_literal: true

module Actions
  module Bonuses
    class Calculate
      class BonusStruct < Dry::Struct
        include Macros
        transform_keys(&:to_sym)

        attribute :applied, Types::Strict::Bool
        attribute :price, Types.Instance(Money)
        attribute :quantity, Types::Strict::Integer
      end
    end
  end
end
