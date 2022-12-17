# frozen_string_literal: true

module PGB
  # TODO Need separation between Identifier and ColumnReference?
  class ColumnReference < Expression
    def initialize(table, column)
      @value = "#{Identifier.new(table)}.#{Identifier.new(column)}"
    end

    def to_sql
      value
    end

    private

    attr_reader :value
  end
end
