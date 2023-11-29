# frozen_string_literal: true

class API::V2::Event::TargetSerializer < API::V2::ApplicationSerializer
  set_type :target

  attributes :target_id, :target_type
end
