# frozen_string_literal: true

class RenameWelcomeVideoAttachments < ActiveRecord::Migration[6.0]
  def up
    ActiveStorage::Attachment.where(record_type: 'DefaultVideo').update_all(record_type: 'WelcomeVideo')
  end

  def down
    ActiveStorage::Attachment.where(record_type: 'WelcomeVideo').update_all(record_type: 'DefaultVideo')
  end
end
