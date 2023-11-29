# frozen_string_literal: true

class Event::CabinEvent < Event
  has_many :cabins, through: :targets, source: :target, source_type: 'Cabin'

  validates :cabin_ids, length: { minimum: 1 }
end
