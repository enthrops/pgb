# frozen_string_literal: true

module PGB
  module Mutable
    def mutable(method)
      original_method = "original_#{method}"
      alias_method original_method, method

      define_method("#{method}!") do |*args, **opts, &block|
        public_send(original_method, *args, **opts, &block)
        self
      end

      define_method(method) do |*args, **opts, &block|
        copy = dup
        copy.instance_exec { public_send(original_method, *args, **opts, &block) }
        copy
      end
    end
  end
end
