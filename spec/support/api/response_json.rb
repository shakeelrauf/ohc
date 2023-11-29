# frozen_string_literal: true

def response_json
  JSON.parse(response.body)
end
