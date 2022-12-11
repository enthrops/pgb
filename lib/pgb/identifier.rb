# frozen_string_literal: true

module PGB
  class Identifier < Expression
    def initialize(value)
      @value = "\"#{value.to_s.gsub('"', '""')}\""
    end

    def to_sql
      value
    end

    private

    attr_reader :value
  end
end
