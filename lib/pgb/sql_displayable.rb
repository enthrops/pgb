# frozen_string_literal: true

module PGB
  module SQLDisplayable
    def to_s
      to_sql
    end

    def inspect
      to_sql
    end
  end
end
