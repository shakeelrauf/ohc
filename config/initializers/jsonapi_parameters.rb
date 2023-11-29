# frozen_string_literal: true

# Transform all JSON API request parameter names to be snake_cased to be in the format Rails (developers) expect
JsonApi::Parameters.ensure_underscore_translation = true
