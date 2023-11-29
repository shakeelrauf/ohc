# frozen_string_literal: true

class Import
  class CampCSV
    class RowProcessor
      ROW_DATA_CLASS = RowData

      include Concerns::RowProcessorMethods

      private

      def find_cabin
        cabin = @scope.cabins.find_by(name: @row_data.cabin)

        @errors << "Cabin '#{@row_data.cabin}' could not be found." if cabin.blank?

        cabin
      end
    end
  end
end
