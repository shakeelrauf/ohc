# frozen_string_literal: true

class API::V2::BaseController < ActionController::API
  BAD_REQUEST_ERROR_CODE = 400

  before_action :authenticate_user

  include ActionController::HttpAuthentication::Token::ControllerMethods
  include TenantUtils

  def authenticate_user
    head :unauthorized unless current_user
  end

  def current_user
    @current_user ||= current_authentication&.users
                                            &.find_by(tenant_id: token_tenant_id)
                                            &.accessed!
  end

  def current_authentication
    @current_authentication ||= authenticate_token&.first&.authentication
  end

  private

  def current_ability
    @current_ability ||= Abilities::API.new(current_user)
  end

  def token_tenant_id
    @token_tenant_id ||= authenticate_token&.last
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      tenant_id, authentication_token = token.split('.')

      api_session = Authentication::Token::APISession.valid
                                                     .includes(authentication: :users)
                                                     .find_by(token: authentication_token)

      return nil unless api_session && tenant_id

      api_session.accessed!

      [api_session, tenant_id]
    end
  end

  def render_object_error(object:, serializer:, status: :unprocessable_entity)
    errors = []

    object.errors.details.each do |error_key, error_hashes|
      error_hashes.each do |error_hash|
        errors << [error_key, error_hash]
      end
    end

    render json: API::V2::ErrorSerializer.new(errors, params: { model: object, model_serializer: serializer }).serialized_json, status: status
  end

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  rescue_from ActionController::ParameterMissing do
    head :unprocessable_entity
  end

  # Rescue from ArgumentErrors that originate from fast_jsonapi serializers that alert to include values
  # that are not supported by the given serializer.
  rescue_from ArgumentError do |exception|
    # We unfortunately have to match on the exception's message rather than type, as the generic
    # ArgumentError is used, with now more direct way of identifying the exceptions we're interested in
    raise exception unless exception.message =~ /is not specified as a relationship on/

    invalid_valid = exception.message.split.first

    errors = [
      {
        status: BAD_REQUEST_ERROR_CODE,
        code: 'UNSUPPORTED_INCLUDE',
        title: 'Query option \'include\' contained an unsupported value.',
        detail: "#{invalid_valid} is not a supported related resource.",
        source: {
          parameter: 'include'
        }
      }
    ]

    render json: { errors: errors }, status: BAD_REQUEST_ERROR_CODE
  end

  # Extracts the standard JSON API arguments from params
  #
  # @note This is partially implemented - there are likely more parameters included in the specification
  #       than are currently supported here.
  def serializer_params
    {
      # Inclusion of associated resources.
      #
      # @note Rather than attempt to validate against a whitelist on a per-request or per-serializer basis,
      #       we pass the results to the serializer and let it raise an ArgumentError which we rescue from
      #       (above) and render a standard error response.
      #
      # @see https://jsonapi.org/format/#fetching-includes
      include: (params[:include] || '').split(',').map(&:underscore)
    }
  end
end
