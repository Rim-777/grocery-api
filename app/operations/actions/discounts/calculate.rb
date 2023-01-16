# frozen_string_literal: true

module Actions
  module Discounts
    class Calculate
      prepend BaseOperation

      option :product, type: Types.Instance(Product)
      option :quantity, type: Types::Strict::Integer

      attr_reader :result

      def call
        init_result
        calculate_discount
      end

      private

      def init_result
        prices = []

        @quantity.times do
          prices << @product.price
        end

        @result = DiscountStruct.new(prices: prices, applied: false)
      end

      def calculate_discount
        return if discount_not_applicable?

        prices = (
          (@product.price * @quantity) * action_discount.coefficient
        ).split(@quantity)

        @result = DiscountStruct.new(prices: prices, applied: true)
      end

      def action_discount
        @action_discount ||=
          @product.actions.find_by(type: Action::Discount.name)
      end

      def quantity_applicable?
        @quantity >= action_discount.min_quantity
      end

      def discount_applicable?
        action_discount.present? && quantity_applicable?
      end

      def discount_not_applicable?
        !discount_applicable?
      end
    end
  end
end
