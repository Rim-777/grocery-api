# frozen_string_literal: true

module Actions
  module Bonuses
    class Calculate
      prepend BaseOperation

      option :product, type: Types.Instance(Product)
      option :quantity, type: Types::Strict::Integer

      attr_reader :result

      def call
        init_result
        calculate_bonus
      end

      def init_result
        @result =
          BonusStruct.new(
            quantity: 0,
            applied: false,
            price: @product.price
          )
      end

      def calculate_bonus
        return unless bonus_applied?

        @result =
          BonusStruct.new(
            quantity: result_quantity,
            applied: bonus_applied?,
            price: Money.new(0)
          )
      end

      private

      def action_bonus
        @product_action_bonus ||=
          @product.actions.find_by(type: Action::Bonus.name)
      end

      def bonus_applied?
        @bonus_applied ||= action_bonus.present?
      end

      def result_quantity
        action_bonus.bonus_quantity * @quantity
      end
    end
  end
end
