# frozen_string_literal: true

class AddTenantReferenceToTopLevelResources < ActiveRecord::Migration[6.0]
  def change
    add_reference :camp_locations, :tenant
    add_reference :camper_questions, :tenant
    add_reference :contact_email_messages, :tenant
    add_reference :events, :tenant
    add_reference :imports, :tenant
    add_reference :media_items, :tenant
    add_reference :streams, :tenant
    add_reference :themes, :tenant
    add_reference :users, :tenant
    add_reference :welcome_videos, :tenant
  end
end
