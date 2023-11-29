# frozen_string_literal: true

class Import < ApplicationRecord
  include TenantResource

  enum status: {
    queued: 'queued',
    processing: 'processing',
    successful: 'successful',
    errored: 'errored'
  }

  belongs_to :scope, polymorphic: true

  has_one_attached :csv_file

  validates :csv_file, attached: true, content_type: %w[text/csv application/csv application/vnd.ms-excel]
  validates :percent_completion, numericality: { only_integer: true },
                                 inclusion: { in: 0..100 },
                                 allow_nil: true

  after_commit :queue!, on: :create

  def queue!
    import_job = job_class.perform_later(self)
    self.update(job_id: import_job&.provider_job_id)
  end

  private

  def job_class
    case scope_type
    when 'Camp'
      CampImportJob
    else
      raise 'Unsupported scope'
    end
  end
end
