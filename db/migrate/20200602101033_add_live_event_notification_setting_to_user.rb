# frozen_string_literal: true

class AddLiveEventNotificationSettingToUser < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.boolean :live_event_notification, default: true
    end
  end
end
