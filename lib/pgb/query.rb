# frozen_string_literal: true

module PGB
  class Query < Expression
    include Executable
    extend Mutable

    # TODO Support everything https://www.postgresql.org/docs/current/sql-select.html
    # TODO Table can be other things, e.g. query

    def initialize(table = nil, *expressions)
      self.table = table
      self.expressions = expressions
    end

    # TODO Can not select star if no table
    def to_sql
      "SELECT #{expressions.any? ? expressions.map(&:to_sql).join(', ') : '*'}".then do
        table ? "#{_1} FROM #{table}" : _1
      end
    end

    mutable def from(table, &block)
      self.table = evaluate_arg(table, &block)
    end

    # TODO Naming for adding, removing, replacing selects
    # TODO Raise if no expressions?
    mutable def select(*expressions, &block)
      self.expressions = evaluate_arg(expressions, &block)
    end

    def color
      :blue
    end

    private

    attr_reader :table
    attr_reader :expressions

    def table=(table)
      @table = table ? to_identifier(table) : nil
    end

    def expressions=(expressions)
      @expressions = expressions.map { to_expression(_1) }
    end
  end
end
