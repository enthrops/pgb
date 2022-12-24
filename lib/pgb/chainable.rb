# frozen_string_literal: true

module PGB
  module Chainable
    def self.extended(base)
      base.instance_exec do
        class << self
          attr_reader :chain_methods

          private

          attr_writer :chain_methods
        end

        self.chain_methods = []
      end
    end

    def chain(method)
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

      chain_methods << method.to_s
      chain_methods << "#{method}!"
    end
  end
end
