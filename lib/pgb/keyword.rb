# frozen_string_literal: true

module PGB
  class Keyword < Expression
    SUPPORTED_VALUES = %w[TRUE FALSE NULL].freeze

    def initialize(value)
      if SUPPORTED_VALUES.include?(normalized(value))
        @value = normalized(value)
      else
        raise Error, "Unsupported keyword: #{value.inspect}"
      end
    end

    def to_sql
      value
    end

    private

    attr_reader :value

    def normalized(value)
      value.to_s.upcase
    end
  end
end
