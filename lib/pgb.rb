# frozen_string_literal: true

# TODO SQL pretty format
# TODO DDL https://www.postgresql.org/docs/current/ddl.html
# TODO Parenthesis in to_sql
# TODO RBS DRY type definitions
# TODO RBS line length
# TODO RBS update signatures
# TODO Parse strings and symbols as identifiers by default?
# TODO Enumerable methods on queries and commands?
# TODO Do we need to repeat execution on already executed queries and commands?
# TODO Enumerable clashes and behavior on queries and commands
# TODO Lazy enumerable on queries and commands
# TODO Rails support
# TODO README
# TODO Rubocop
# TODO Supported ruby versions
# TODO Specs
# TODO CI
# TODO Push gem
# TODO Performance
# TODO Clean up changelog when somewhat stable
# TODO Comments + comment cops
# TODO Relax runtime dependency versions
# TODO Go through everything
# TODO Go through all TODOS

require 'colorized_string'
require 'pg'
require 'zeitwerk'

module PGB
  class << self
    attr_accessor :loader
    attr_accessor :load_queries_on_inspect
  end

  self.load_queries_on_inspect = false
end

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('pgb' => 'PGB', 'sql_displayable' => 'SQLDisplayable')
loader.enable_reloading
loader.setup

PGB.loader = loader

module PGB
  SUPPORTED_PG_VERSIONS = (11..15).freeze
  WORKING_DIR = Dir.pwd

  class Error < StandardError
  end

  class << self
    def evaluate(&block)
      EvaluationContext.new.instance_exec(&block)
    end

    # TODO Log
    # TODO Connection pool
    # TODO DB connection params
    # TODO Extract
    # TODO Wrap errors in PGB::Error
    # TODO Support block evaluation
    # TODO Log runtime
    # TODO Log source of query
    # TODO Look through everything
    # TODO Enable all rubocop cops
    # TODO Coloring if supported
    def execute(command)
      if command.is_a?(Executable)
        sql         = command.to_sql
        display_sql = ColorizedString[sql].colorize(command.color)
      else
        sql         = command
        display_sql = command.strip.tr("\n", ' ')
      end

      # TODO Weird
      connection
      log(display_sql)
      connection.exec(sql).to_a
    end

    # TODO Connection lost? Reconnect? Different version?
    def connection
      @connection ||= begin
        connection = PG.connect(dbname: ENV.fetch('DB'))
        ensure_pg_version_supported(connection)
        connection
      end
    end

    # TODO Different backtrace order in different ruby versions?
    # TODO Disable sql logging?
    # TODO Disable caller logging?
    # TODO Log failed requests in a different color
    # TODO Check colorization is supported? Or is it ok when not supported? What about log files?
    def log(sql)
      log_line = sql

      frame = caller.find { !_1['/lib/ruby/gems/'] && _1.start_with?('/') }
      if frame
        # TODO Wrong dir, get current executing dir?
        frame = frame.gsub("#{WORKING_DIR}/", '').strip
        # TODO Do not display if not a file?
        log_line += ColorizedString[" -- #{frame}"].light_black unless frame.empty?
      end

      puts log_line
    end

    # TODO Check expected response format
    def ensure_pg_version_supported(connection)
      sql = 'SELECT version()'
      log(sql)
      version = Integer(connection.exec(sql).first.fetch('version').match(/PostgreSQL (\d+)\./)[1])
      unless SUPPORTED_PG_VERSIONS.include?(version)
        raise Error, "Unsupported Postgres version: #{version}, supported: #{SUPPORTED_PG_VERSIONS}"
      end
    end

    # TODO Extract
    # TODO Model is not a table name (e.g. query)?
    # TODO Do not select all columns
    # TODO Request as PGB query
    # TODO Support getting schema for all tables
    # TODO Remove line breaks for raw queries?
    # TODO Check expected response format
    def schema(table_name)
      table_name = table_name.to_s
      @schema ||= begin
        result = execute <<~SQL
          SELECT *
          FROM information_schema.columns
          WHERE table_schema = 'public'
        SQL
        result.group_by { _1['table_name'] }
      end

      schema = @schema.fetch(table_name) do
        raise Error, "Failed to load schema for #{table_name.inspect}"
      end

      schema.group_by { _1['column_name'] }.transform_values(&:first)
    end
  end
end
