# frozen_string_literal: true

module PGB
  class TypeCast < Expression
    # TODO Support non-integer args (e.g. for interval)

    def initialize(value, type, *args)
      @value = Expression.from(value)
      @type = type.to_s.strip.downcase
      @args = args.map { Literal.new(_1) }
    end

    def to_sql
      type_description = args.any? ? "#{type}(#{args.join(', ')})" : type

      case value
      when OperatorCall, Query, TypeCast
        "(#{value})::#{type_description}"
      else
        "#{value}::#{type_description}"
      end
    end

    private

    attr_reader :value
    attr_reader :type
    attr_reader :args
  end
end
