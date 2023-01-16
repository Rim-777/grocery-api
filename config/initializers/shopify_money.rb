# frozen_string_literal: true

Money.configure do |config|
  config.default_currency = Money::Currency.new('EUR')
end
