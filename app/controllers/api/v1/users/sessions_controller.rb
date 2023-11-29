# frozen_string_literal: true

class API::V1::Users::SessionsController < API::V1::BaseController
  # == [GET] /api/v1/users/sessions.json
  # Force all v1 clients to logout
  # ==== Returns
  # * 401 - unauthorized
  def show
    head :unauthorized
  end

  # == [DELETE] /api/v1/users/sessions.json
  def destroy
    head :no_content
  end
end
