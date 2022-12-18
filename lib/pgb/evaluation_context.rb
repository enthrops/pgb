# frozen_string_literal: true

module PGB
  class EvaluationContext
    include Shortcuts

    # rubocop:disable Style/MissingRespondToMissing
    def method_missing(method, *args, &block)
      if args.empty?
        Identifier.new(method)
      else
        FunctionCall.new(method, *args)
      end
    end
    # rubocop:enable Style/MissingRespondToMissing
  end
end
