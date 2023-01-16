# frozen_string_literal: true

class ProductsAction < ApplicationRecord
  belongs_to :product,
             class_name: Product.name,
             inverse_of: :products_actions

  belongs_to :action,
             class_name: Action.name,
             inverse_of: :products_actions

  validates :product_id, uniqueness: { scope: :action_id }
end
