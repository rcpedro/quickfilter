module Quickfilter
  module Handlers
    SQL = {
      eq:          lambda { |field, value| ["#{field} = ?", value] },
      eqic:        lambda { |field, value| ["lower(#{field}) = ?", "#{value.downcase}"] },
      likeic:      lambda { |field, value| ["lower(#{field}) like ?", "#{value.downcase}"] },
      startswith:  lambda { |field, value| ["lower(#{field}) like ?", "#{value.downcase}%"] },
      contains:    lambda { |field, value| ["lower(#{field}) like ?", "%#{value.downcase}%"] },

      gt:  lambda { |field, value| ["#{field} > ?",  value] },
      gte: lambda { |field, value| ["#{field} >= ?", value] },
      lt:  lambda { |field, value| ["#{field} < ?",  value] },
      lte: lambda { |field, value| ["#{field} <= ?", value] },

      in:      lambda { |field, value| ["#{field} in (?)", value] },
      isnull:  lambda { |field, value| [field, (value.present? and value) ? 'null' : 'not null'] }
    }

    PG = {
      sameday:   lambda { |field, value| ["date_trunc('day',   #{field}) = ?", value.to_date] },
      sameweek:  lambda { |field, value| ["date_trunc('week',  #{field}) = ?", value.to_date.beginning_of_week] },
      samemonth: lambda { |field, value| ["date_trunc('month', #{field}) = ?", value.to_date.beginning_of_month] }
    }

    class << self
      def get(name, adapter)
        result = SQL[name]
        result ||= PG[name] if self.is_pg?(adapter)

        raise "Operation #{name} not supported for adapter #{adapter}." if result.nil?
        return result
      end

      def is_pg?(adapter)
        return adapter == 'postgresql'
      end
    end
  end
end