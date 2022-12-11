# frozen_string_literal: true

module PGB
  # TODO Explicit table names
  # TODO Support queries for from
  # TODO Automatically infer validations from db constraints
  # TODO Do not litter this class with methods since others inherit from it (e.g. parse)
  # TODO Support explicitly setting table_name / query / etc
  # TODO table_name changing at runtime
  # TODO Defined attributes might be needed before connecting to the database
  # TODO Support keyword attributes for #new and make parse use that
  # TODO #inspect
  # TODO #to_s
  # TODO Module inclusions on relations?
  # TODO Include enumerable methods unless they clash with existing
  # TODO Enumerable methods should act on current selection
  # TODO Check all enumerable methods are functional (e.g. sort, to_h)
  # TODO Implement base methods, e.g. ==, etc
  # TODO Check Enumerable and Shortcuts methods clashing (e.g. [])
  # TODO Lazy for enumerable
  class Model
    # TODO These two should respect already constructed relations
    include Shortcuts

    class << self
      include Enumerable
      include Shortcuts

      attr_reader :table_name

      def inherited(klass)
        # TODO Bad method for setting table name
        klass.table_name = "#{klass.name.downcase.split('::').last}s"
      end

      def each
        all.each { yield _1 }
      end

      # TODO Only execute when data is required
      # TODO Schema auto reload?
      # TODO Schema manual reload?
      # TODO Called again? Remove all conditions or do nothing?
      def all
        from(table_name).then { execute(_1) }.map { parse(_1) }
      end

      # TODO Column names clashing with existing methods
      # TODO Overwriting column readers / writers
      def schema
        @schema ||= class_exec do
          PGB.schema(table_name).each_key do
            attr_accessor _1
          end
        end
      end

      def columns
        schema.keys
      end

      protected

      attr_writer :table_name

      private

      # TODO Column in schema, but not in result
      # TODO Column in result, but not in schema
      # TODO Enums
      # TODO Custom type read / write
      def parse(row)
        object = new
        columns.each { |column| object.public_send("#{column}=", to_ruby_type(row, column)) }
        object
      end

      # TODO More types
      # TODO Numeric types in old rubies?
      # TODO Auto ? for booleans? (non-null only?)
      # TODO Compare objects by schema, invalidate old ones?
      # TODO Cut extract schema keys
      def to_ruby_type(row, column)
        value = row.fetch(column)
        return unless value

        type = schema.fetch(column).fetch('data_type')
        case type
        when 'bigint', 'integer', 'smallint'
          Integer(value)
        when 'character varying'
          value
        when 'boolean'
          parse_boolean(value)
        when 'jsonb'
          JSON.parse(value)
        when 'timestamp without time zone', 'date', 'USER-DEFINED'
          # TODO USER-DEFINED = citext, enum, others
          "#{value} ! TODO"
        else
          raise Error, "Unknown db type: #{type}"
        end
      end

      def parse_boolean(value)
        case value
        when 't'
          true
        when 'f'
          false
        else
          raise Error, "Unknown boolean db representation: #{value.inspect}"
        end
      end
    end
  end
end
