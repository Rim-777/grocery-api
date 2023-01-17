# frozen_string_literal: true

module Types
  include Dry.Types()
  NumericString = String.constrained(format: /^(\d)+$/)
end
