# frozen_string_literal: true

class Import
  module Concerns
    module ExtractCSVRowData
      def self.included(base)
        base.class_eval do
          attr_accessor :row_data
        end
      end

      def initialize(row_data)
        self.row_data = row_data

        define_data_accessors
      end

      protected

      def define_data_accessors
        self.class::CSV_HEADERS.each do |key, value|
          self.class.send(:define_method, key) { row_data[value] }
        end
      end
    end
  end
end
