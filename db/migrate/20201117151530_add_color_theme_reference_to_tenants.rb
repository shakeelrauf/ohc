# frozen_string_literal: true

class AddColorThemeReferenceToTenants < ActiveRecord::Migration[6.0]
  def change
    add_reference :tenants, :color_theme
  end
end
