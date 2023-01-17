# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  currency   :string(3)        not null
#  name       :string           not null
#  price      :decimal(21, 12)  not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_products_on_code  (code) UNIQUE
#
FactoryBot.define do
  factory :product do
  end
end
