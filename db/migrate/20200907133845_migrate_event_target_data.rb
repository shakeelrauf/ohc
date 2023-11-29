# frozen_string_literal: true

class MigrateEventTargetData < ActiveRecord::Migration[6.0]
  def up
    Event.where.not(target_type: nil).each do |event|
      Event::Target.create(event: event, target_id: event.target_id, target_type: event.target_type)
    end

    remove_reference :events, :target, polymorphic: true
  end

  def down
    add_reference :events, :target, polymorphic: true

    Event::Target.each do |event_target|
      event_target.event.update(target_id: event_target.target_id, target_type: event_target.target_type)
    end
  end
end
