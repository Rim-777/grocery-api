# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsAction, type: :model do
  it { should belong_to(:action).inverse_of(:products_actions) }
  it { should belong_to(:product).inverse_of(:products_actions) }
  it { should validate_uniqueness_of(:product_id).scoped_to(:action_id) }
end
