# frozen_string_literal: true

class Event::CampEvent < Event
  has_many :camps, through: :targets, source: :target, source_type: 'Camp'

  validates :camp_ids, length: { minimum: 1 }
end
