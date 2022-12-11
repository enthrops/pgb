# frozen_string_literal: true

module PGB
  # TODO Support dynamic param evaluation
  module Shortcuts
    extend self

    def execute(...)
      PGB.execute(...)
    end

    def select(...)
      PGB::Query.new(nil, ...)
    end

    def from(table)
      PGB::Query.new(table)
    end

    def func(...)
      PGB::FunctionCall.new(...)
    end

    def lit(...)
      PGB::Literal.new(...)
    end

    def [](...)
      PGB::Identifier.new(...)
    end
  end
end
