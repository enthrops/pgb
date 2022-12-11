# frozen_string_literal: true

module PGB
  module Executable
    include Enumerable

    def each
      PGB.execute(self).each { yield _1 }
    end
  end
end
