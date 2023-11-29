# frozen_string_literal: true

class CreateImports < ActiveRecord::Migration[6.0]
  def change
    create_table :imports do |t|
      t.string :error
      t.string :status, default: 'queued'
      t.string :job_id
      t.integer :percent_completion
      t.references :scope, polymorphic: true
      t.timestamps
    end
  end
end
