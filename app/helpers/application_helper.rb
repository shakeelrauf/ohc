# frozen_string_literal: true

module ApplicationHelper
  def project_name
    Rails.application.secrets.project_name
  end
end
