# frozen_string_literal: true

require 'csv'
require 'active_record'

class Import
  class CSVBase
    FIRST_ROW_AFTER_HEADER = 2
    REQUIRED_ENCODING = 'UTF-8'

    def initialize(import_record)
      import_record.processing!
      @import_record = import_record
      @tenant = import_record.tenant
    end

    # Initiates the import
    def execute
      log_warning 'Initiating Camper Import'

      execute_import_in_transaction!
    rescue Import::Error => error
      process_error(error)
    rescue StandardError => error
      # NOTE: Sometimes the import runs before active storage has chance to correctly save the file
      # re-raise the error here so the job can be rerun by 'retry_on' in `CampImportJob`
      raise ActiveStorage::FileNotFoundError if error.is_a?(ActiveStorage::FileNotFoundError)

      Airbrake.notify('Critical Import Failure', message: error.message, backtrace: error.backtrace)
      process_error(error)
    else
      @import_record.successful!
      log_warning 'Finished Camper Import'
    end

    def custom_logger
      @custom_logger ||= begin
        # Creates a folder within '/log/' with the current environment name. This allows use to clean
        # up import logs easier.
        FileUtils.mkdir_p("log/#{Rails.application.secrets.error_environment}")
        Logger.new("log/#{Rails.application.secrets.error_environment}/#{self.class.name.demodulize.underscore}.log")
      end
    end

    def log_warning(message)
      custom_logger.warn message
    end

    private

    def execute_import_in_transaction!
      ActiveRecord::Base.transaction do
        current_row_number = FIRST_ROW_AFTER_HEADER
        file = @import_record.csv_file.download

        # Make sure the CSV data is converted to UTF-8
        detection = CharlockHolmes::EncodingDetector.detect(file)

        file = CharlockHolmes::Converter.convert(file, detection[:encoding], REQUIRED_ENCODING)

        file_linelength = file.size

        CSV.new(file, headers: true).each do |row_data|
          for_each_row(row_data, current_row_number)

          percent_complete = ((current_row_number - 1) / file_linelength.to_f) * 100

          @import_record.update(percent_completion: percent_complete.to_i)

          current_row_number += 1
        end
      end
    end

    def process_error(error)
      @import_record.error = error.message
      @import_record.percent_completion = 0
      @import_record.errored!

      log_warning 'Camp Import Failure'
      log_warning error.message
    end

    def for_each_row(row_data, row_number)
      processed_row = self.class::ROW_PROCESSOR_CLASS.new(row_data, @import_record.scope, @tenant).execute

      raise Import::Error, "Row #{row_number}: #{processed_row.errors.join(', ')}" if processed_row.errors.any?
    end
  end
end
