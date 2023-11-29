# frozen_string_literal: true

class RemoveTenancyFromStreams < ActiveRecord::Migration[6.0]
  def change
    remove_reference :streams, :tenant
  end
end
