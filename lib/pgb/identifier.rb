# frozen_string_literal: true

module PGB
  # TODO Need separation between Identifier and ColumnReference?
  class Identifier < Expression
    def initialize(value)
      @value = case value
               when Identifier
                 value.value
               when String, Symbol
                 "\"#{value.to_s.gsub('"', '""')}\""
               else
                 raise Error, "Can not convert type to identifier: #{value.class}"
               end
    end

    def [](column)
      ColumnReference.new(value, column)
    end

    def to_sql
      value
    end

    protected

    attr_reader :value
  end
end
