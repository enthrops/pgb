# frozen_string_literal: true

module PGB
  class EvaluationContext
    include Shortcuts

    # TODO Evaluate multiple args?
    # TODO Implement respond_to_missing and remove cop skip?
    # rubocop:disable Style/MissingRespondToMissing
    def method_missing(*args, **opts, &block)
      if args.one?
        Identifier.new(args.first)
      else
        super
      end
    end
    # rubocop:enable Style/MissingRespondToMissing
  end
end
