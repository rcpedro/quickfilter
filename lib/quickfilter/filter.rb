require 'quickfilter/handlers'

module Quickfilter
  class Filter

    attr_accessor :field, :operator, :value, :adapter

    def initialize(table, field, operator, value, adapter)
      self.field = "#{table}.#{field}"
      self.operator = operator
      self.value = value
      self.adapter = adapter
    end

    def build
      return nil if self.value.blank?
      return Quickfilter::Handlers.get(self.operator, self.adapter).call(self.field, self.value)
    end
  end
end