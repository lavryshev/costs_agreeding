module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(selected_filters)
      results = self.where(nil)
      selected_filters.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end