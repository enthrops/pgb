# frozen_string_literal: true

module PGB
  class Expression
    include SQLDisplayable

    private

    include Casting

    # TODO Multiple args?
    def evaluate_arg(arg, &block)
      if block
        EvaluationContext.new.instance_exec(&block)
      else
        arg
      end
    end
  end
end
