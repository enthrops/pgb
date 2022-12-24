# frozen_string_literal: true

module PGB
  # TODO Support lazy via cursors
  module Executable
    def to_a
      PGB.execute(self)
    end

    def execute
      to_a
    end

    def method_missing(method, *args, &block)
      if Array.public_method_defined?(method)
        to_a.public_send(method, *args, &block)
      else
        super
      end
    end
  end
end
