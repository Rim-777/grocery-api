# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action, type: :model do
  it 'associates action with products_actions' do
    should have_many(:products_actions)
             .class_name(ProductsAction.name)
             .inverse_of(:action)
             .dependent(:destroy)
  end

  it 'associates action with products' do
    should have_many(:products).through(:products_actions)
  end
end
