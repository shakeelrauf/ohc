# frozen_string_literal: true

class SetEventTypes < ActiveRecord::Migration[6.0]
  def up
    Event.find_each do |event|
      case event.target_type
      when 'Cabin'
        event.becomes!(Event::CabinEvent)
      when 'Camp'
        event.becomes!(Event::CampEvent)
      else
        event.becomes!(Event::NationalEvent)
      end

      event.save!
    end
  end

  def down; end
end
