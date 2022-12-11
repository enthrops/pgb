# frozen_string_literal: true

module PGB
  class OperatorCall < Expression
    # TODO Validate and parse operators https://www.postgresql.org/docs/current/functions.html

    def initialize(operator, expression1, expression2 = nil)
      @operator = operator.to_s
      @expression1 = to_expression(expression1)
      @expression2 = to_expression(expression2) if expression2
    end

    def to_sql
      if unary?
        "#{operator}#{expression1}"
      else
        "#{expression1} #{operator} #{expression2}"
      end
    end

    private

    attr_reader :operator
    attr_reader :expression1
    attr_reader :expression2

    def unary?
      !expression2
    end

    def binary?
      !unary?
    end
  end
end
