# frozen_string_literal: true

module CartsProducts
  class DeleteCollection
    prepend BaseOperation

    option :attributes, type: Types::Strict::Hash

    def call
      CartsProduct.where(@attributes).delete_all
    end
  end
end
