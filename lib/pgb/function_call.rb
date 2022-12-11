# frozen_string_literal: true

module PGB
  class FunctionCall < Expression
    def initialize(function, *args)
      @function = function.to_s.upcase
      @args = args.map { to_expression(_1) }
    end

    def to_sql
      "#{function}(#{args.map(&:to_sql).join(', ')})"
    end

    private

    attr_reader :function
    attr_reader :args
  end
end
