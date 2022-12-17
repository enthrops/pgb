module PGB
  class Expression
    class Keyword < Expression
      SUPPORTED_VALUES = %w[TRUE FALSE NULL]

      def initialize(value)
        if SUPPORTED_VALUES.include?(normalized(value))
          @value = normalized(value)
        else
          raise Error, "Unsupported keyword: #{value.inspect}"
        end
      end

      def to_sql
        value
      end

      private

      attr_reader :value

      def normalized(value)
        value.to_s.strip.upcase
      end
    end
  end
end
