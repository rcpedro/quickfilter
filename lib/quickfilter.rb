require 'active_support/concern'
require 'active_record'
require 'active_record/reflection'
require 'active_record/relation'

require 'quickfilter/version'
require 'quickfilter/query_builder'


module Quickfilter
  extend ActiveSupport::Concern

  class_methods do
    # Parameters in the form of:
    #   { [table]: { [field]: { [operator]: [value] }}}
    #
    # e.g.:
    #   { courses: { name: { likeic: 'John' }}
    #   { sessions: { start: { gte: DateTime.now - 1.days, lte: DateTime.now }}}
    #
    # Wherein, table is optional and defaults to self.table_name
    def filter(params)
      return QueryBuilder.new(self).build(params).query
    end
  end
end
