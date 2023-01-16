# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsProduct, type: :model do
  it { should belong_to(:cart).inverse_of(:carts_products) }
  it { should belong_to(:product).inverse_of(:carts_products) }
end
