# frozen_string_literal: true

class Action < ApplicationRecord
  has_many :products_actions,
           class_name: ProductsAction.name,
           inverse_of: :action,
           dependent: :destroy

  has_many :products, through: :products_actions
end
