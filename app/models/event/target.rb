# frozen_string_literal: true

class Event::Target < ApplicationRecord
  belongs_to :event
  belongs_to :target, polymorphic: true
end
