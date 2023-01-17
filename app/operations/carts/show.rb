# frozen_string_literal: true

module Carts
  class Show
    prepend BaseOperation

    option :cart_id, type: Types::NumericString | Types::Strict::Integer
    attr_reader :result

    def call
      @result = Cart.find(@cart_id)
    end
  end
end
