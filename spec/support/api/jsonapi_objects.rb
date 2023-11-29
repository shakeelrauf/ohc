# frozen_string_literal: true

def jsonapi_packet(type, attributes, id: '', data: '', include: '', relationships: '')
  response_object = { data: (data.present? ? data : jsonapi_object(type, attributes, id: id, relationships: relationships)) }
  response_object[:include] = include if include.present?

  camelize_keys(response_object)
end

def jsonapi_object(type, attributes, id: '', relationships: '')
  jsonapi_object_hash = {
    type: type,
    attributes: attributes
  }

  jsonapi_object_hash[:id] = id if id.present?
  jsonapi_object_hash[:relationships] = relationships if relationships.present?

  camelize_keys(jsonapi_object_hash)
end

def jsonapi_ref_object(type, id)
  camelize_keys(type: type, id: id)
end

def camelize_keys(underscore_object)
  underscore_object.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
end

def jsonapi_packet_with_include(type, attributes, included = {})
  body = {
    data: jsonapi_object_with_relationships(type, attributes),
    included: included.map do |value|
      jsonapi_object_with_relationships(value[:type], value).merge(id: value[:id])
    end
  }

  body[:data][:id] = attributes[:id] if attributes&.key?(:id)

  body.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
end

def jsonapi_object_with_relationships(type, attributes)
  {
    type: type,
    attributes: attributes&.except(:id, :type, :relationships),
    relationships: attributes[:relationships]
  }
end

def create_relationships(relationships)
  relationships.transform_values { |value| { 'data' => value } }
end
