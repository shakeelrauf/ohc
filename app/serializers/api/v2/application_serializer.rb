# frozen_string_literal: true

class API::V2::ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  include Rails.application.routes.url_helpers

  set_key_transform :camel_lower
end
