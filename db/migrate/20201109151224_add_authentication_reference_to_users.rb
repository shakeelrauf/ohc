# frozen_string_literal: true

class AddAuthenticationReferenceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :authentication
  end
end
