# frozen_string_literal: true

module TenantResource
  extend ActiveSupport::Concern

  included do
    belongs_to :tenant
  end
end
