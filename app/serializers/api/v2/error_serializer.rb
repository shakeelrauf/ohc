# frozen_string_literal: true

# Source: https://github.com/stas/jsonapi.rb/blob/master/lib/jsonapi/active_model_error_serializer.rb
class API::V2::ErrorSerializer < API::V2::ApplicationSerializer
  set_id :object_id
  set_type :error

  attribute :status do
    '422'
  end

  attribute :title do
    Rack::Utils::HTTP_STATUS_CODES[422]
  end

  attribute :code do |object|
    _, error_hash = object
    code = error_hash[:error] unless error_hash[:error].is_a?(Hash)
    code ||= error_hash[:message] || :invalid
    # `parameterize` separator arguments are different on Rails 4 vs 5...
    code.to_s.delete("''").parameterize.tr('-', '_')
  end

  attribute :detail do |object, params|
    error_key, error_hash = object
    errors_object = params[:model].errors

    # Rails 4 provides just the message.
    message = if error_hash[:error].present? && error_hash[:error].is_a?(Hash)
                errors_object.generate_message(
                  error_key, nil, error_hash[:error]
                )
              elsif error_hash[:error].present?
                errors_object.generate_message(
                  error_key, error_hash[:error], error_hash
                )
              else
                error_hash[:message]
              end

    errors_object.full_message(error_key, message)
  end

  attribute :source do |object, params|
    error_key, = object
    model_serializer = params[:model_serializer]
    attrs = (model_serializer.attributes_to_serialize || {}).keys
    rels = (model_serializer.relationships_to_serialize || {}).keys

    if attrs.include?(error_key)
      { pointer: "/data/attributes/#{error_key}" }
    elsif rels.include?(error_key)
      { pointer: "/data/relationships/#{error_key}" }
    else
      { pointer: '' }
    end
  end

  # Remap the root key to `errors`
  #
  # @return [Hash]
  def serializable_hash
    { errors: (super[:data] || []).map { |error| error[:attributes] } }
  end
end
