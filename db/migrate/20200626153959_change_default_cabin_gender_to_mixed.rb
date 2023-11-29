# frozen_string_literal: true

class ChangeDefaultCabinGenderToMixed < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:cabins, :gender, from: nil, to: 'mixed')
  end
end
