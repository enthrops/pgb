module PGB
  class Relation
    include SQLDisplayable
    include Executable

    # TODO Check usage in all conversions

    def initialize(model, query)
      @model = model
      @query = Query.from(query)
    end

    attr_reader :query

    def inspect
      if PGB.load_queries_on_inspect
        # TODO
      else
        "#{model}: #{super}"
      end
    end

    def method_missing(method, *args, &block)
      return super unless query.respond_to?(method)
      return query.public_send(method, *args, &block) unless Query.chain_methods.include?(method)

      if method.end_with?('!')
        self.query = query.dup.public_send(method, *args, &block)
        self
      else
        self.class.new(model, query.public_send(method, *args, &block))
      end
    end

    private

    attr_reader :model
  end
end
