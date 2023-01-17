# frozen_string_literal: true

module Carts
  class Create
    prepend BaseOperation

    attr_reader :result

    def call
      @result = Cart.create!
    rescue ActiveRecord::RecordInvalid => e
      interrupt_with_errors!([e.message])
    end
  end
end
