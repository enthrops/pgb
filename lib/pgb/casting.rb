# frozen_string_literal: true

module PGB
  module Casting
    private

    # TODO More types
    # TODO DRY literal types
    def to_expression(object)
      case object
      when Expression
        object
      when TrueClass
        Keyword.new('TRUE')
      when FalseClass
        Keyword.new('FALSE')
      when NilClass
        Keyword.new('NULL')
      when String, Symbol, Numeric
        Literal.new(object)
      else
        raise Error, "Can not convert type to expression: #{object.class}"
      end
    end

    def to_identifier(object)
      object.is_a?(Identifier) ? object : Identifier.new(object)
    end
  end
end
