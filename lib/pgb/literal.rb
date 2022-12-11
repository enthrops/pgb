# frozen_string_literal: true

module PGB
  class Literal < Expression
    def initialize(value)
      @value = to_db(value).to_s
    end

    def to_sql
      value
    end

    private

    attr_reader :value

    # TODO More types
    def to_db(value)
      case value
      when String, Symbol
        "'#{value.to_s.gsub("'", "''")}'"
      when Numeric
        # TODO Correctly convert different numeric types
        value
      else
        raise Error, "Unsupported type for literal: #{value.class}"
      end
    end
  end
end
