# frozen_string_literal: true

class AddProductContract < Dry::Validation::Contract
  schema do
    required(:data).hash do
      required(:cart_id).filled(:integer)
      required(:product_id).filled(:integer)
      required(:quantity).filled(:integer)
    end
  end
end
