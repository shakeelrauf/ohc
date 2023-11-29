# frozen_string_literal: true

class Import
  class CampCSV
    class RowData
      CSV_HEADERS = {
        cabin: 'Cabin/Small Group',
        date_of_birth: 'Date of Birth (YYYY-MM-DD)',
        email: 'Parent Email',
        first_name: 'First Name',
        gender: 'Gender',
        last_name: 'Last Name'
      }.freeze

      include Concerns::ExtractCSVRowData
    end
  end
end
