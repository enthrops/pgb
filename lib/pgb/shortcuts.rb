# frozen_string_literal: true

module PGB
  module Shortcuts
    extend self

    def execute(...)
      PGB.execute(...)
    end

    def evaluate(...)
      PGB.evaluate(...)
    end

    # TODO
    def select(...)
      Query.new(nil, ...)
    end

    # TODO
    def from(...)
      Query.new(...)
    end

    def fn(...)
      FunctionCall.new(...)
    end

    def lit(...)
      Literal.new(...)
    end

    def [](...)
      Identifier.new(...)
    end

    def op(...)
      OperatorCall.new(...)
    end
  end
end
