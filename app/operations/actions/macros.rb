# frozen_string_literal: true

module Actions
  module Macros
    extend ActiveSupport::Concern

    included do
      def applied?
        applied
      end
    end
  end
end
