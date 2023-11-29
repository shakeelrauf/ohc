# frozen_string_literal: true

class API::V1::ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower
end
