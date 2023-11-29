# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :admin, index: true
      t.references :child
      t.string :text
      t.string :reply

      t.timestamps
    end
  end
end
