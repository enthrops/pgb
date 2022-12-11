# frozen_string_literal: true

module PGB
  class ColumnReference < Expression
    def initialize(table, column)
      @value = "#{to_identifier(table)}.#{to_identifier(column)}"
    end

    def to_sql
      value
    end

    private

    attr_reader :value
  end
end
