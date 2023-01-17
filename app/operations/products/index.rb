# frozen_string_literal: true

module Products
  class Index
    prepend BaseOperation

    attr_reader :result

    def call
      @result = Product.all
    end
  end
end
