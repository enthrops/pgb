# frozen_string_literal: true

module PGB
  class Literal < Expression
    # TODO Correctly represent different numeric types
    # TODO More ruby types
    def initialize(value)
      @value = case value
               when Literal
                 value.value
               when String, Symbol
                 "'#{value.to_s.gsub("'", "''")}'"
               else
                 value.to_s
               end
    end

    def to_sql
      value
    end

    protected

    attr_reader :value
  end
end
