# frozen_string_literal: true

require 'csv'

class Camp
  CSV_HEADERS = ['Code',
                 'First Name',
                 'Last Name',
                 'Date of Birth (YYYY-MM-DD)',
                 'Gender',
                 'Parent Email',
                 'Cabin/Small Group'].freeze

  class CSV
    def self.generate(camp)
      attendances = camp.attendances.includes(:user).order('users.last_name, users.first_name')

      ::CSV.generate(headers: true) do |csv|
        csv << CSV_HEADERS

        attendances.of_admins.each { |attendance| csv << attendance.to_csv_row }
        attendances.of_children.each { |attendance| csv << attendance.to_csv_row }
      end
    end
  end
end
