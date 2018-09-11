require 'quickfilter/filter'

module Quickfilter
  class QueryBuilder
    attr_reader :klass, :query, :adapter

    def initialize(klass, adapter=nil)
      @klass = klass
      @query = klass.where(nil)
      @associations = klass.reflect_on_all_associations

      @adapter = adapter
      @adapter ||= ActiveRecord::Base.connection_config[:adapter]
    end

    def build(params)
      params.each do |param|
        self.with(param) do |tablename, fieldname, operator, value|
          self.filter(tablename, fieldname, operator, value)
          self.join(tablename) if tablename != @klass.table_name
        end
      end
      return self
    end

    protected
      def filter(tablename, fieldname, operator, value)
        filter = Filter.new(tablename, fieldname, operator, value, @adapter)
        @query = @query.where(filter.build)
        return self
      end

      def join(tablename)
        @query = @query.joins(self.association_for(tablename)) 
        return self
      end

      def with(param)
        param[1].each do |second|
          if second[1].is_a?(Hash)
            second[1].each do |operator, value| 
              next if value.nil?
              yield(param[0], second[0], operator, value)
            end
          else
            next if second[1].nil?
            yield(@klass.table_name, param[0], second[0], second[1])
          end
        end
      end
    
      def association_for(table)
        @associations.each do |assoc|
          return assoc.name if table.to_s == assoc.table_name
        end
      end
  end
end