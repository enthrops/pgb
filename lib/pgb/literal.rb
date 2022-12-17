# frozen_string_literal: true

module PGB
  class Literal < Expression
    def initialize(value)
      @value = to_db(value)
    end

    def to_sql
      value
    end

    protected

    attr_reader :value

    private

    # TODO Correctly represent different numeric types
    def to_db(value)
      case value
      when Literal
        value.value
      when String, Symbol
        "'#{value.to_s.gsub("'", "''")}'"
      else
        value.to_s
      end
    end
  end
end
