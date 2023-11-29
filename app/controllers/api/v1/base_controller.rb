# frozen_string_literal: true

class API::V1::BaseController < ActionController::API
  private

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  rescue_from ActionController::ParameterMissing do
    head :unprocessable_entity
  end
end
