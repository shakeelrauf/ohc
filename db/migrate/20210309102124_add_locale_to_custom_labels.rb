# frozen_string_literal: true

class AddLocaleToCustomLabels < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_labels, :locale, :string, default: 'en'
  end
end
