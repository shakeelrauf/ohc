# frozen_string_literal: true

class CampImportJob < ApplicationJob
  queue_as :default

  discard_on ActiveJob::DeserializationError
  discard_on ActiveRecord::RecordNotFound

  retry_on ActiveStorage::FileNotFoundError

  def perform(import_record)
    Import::CampCSV.new(import_record).execute
  end
end
