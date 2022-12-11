# frozen_string_literal: true

module PGB
  class Command
    include SQLDisplayable
    include Casting
    include Executable
  end
end
