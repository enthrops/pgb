# frozen_string_literal: true

module PGB
  class OperatorCall < Expression
    UNDEFINED_ARGUMENT = Object.new

    def initialize(operator, expression1, expression2 = UNDEFINED_ARGUMENT)
      @operator = operator.to_s
      @expression1 = Expression.from(expression1)
      @expression2 = Expression.from(expression2) unless expression2 == UNDEFINED_ARGUMENT
    end

    def to_sql
      if unary?
        "#{operator}#{wrap(expression1)}"
      else
        "#{wrap(expression1)} #{operator} #{wrap(expression2)}"
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

    def wrap(value)
      if unary? && (value.is_a?(OperatorCall) || value.is_a?(TypeCast) || value.is_a?(Query))
        "(#{value})"
      elsif binary? && (value.is_a?(OperatorCall) || value.is_a?(Query))
        "(#{value})"
      else
        value
      end
    end
  end
end
