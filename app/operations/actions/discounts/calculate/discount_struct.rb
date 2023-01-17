# frozen_string_literal: true

module Actions
  module Discounts
    class Calculate
      class DiscountStruct < Dry::Struct
        include Macros
        transform_keys(&:to_sym)

        attribute :applied, Types::Strict::Bool
        attribute :prices, Types::Strict::Array.of(Types.Instance(Money))
      end
    end
  end
end
