# frozen_string_literal: true

class AddAppLayoutToColourThemes < ActiveRecord::Migration[6.0]
  def up
    add_column :color_themes, :app_layout, :string

    ColorTheme.update_all(app_layout: 'faith_spark')
  end

  def down
    remove_column :color_themes, :app_layout
  end
end
