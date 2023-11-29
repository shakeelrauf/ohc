# frozen_string_literal: true

class AssignAdminGenders < ActiveRecord::Migration[6.0]
  def up
    User::Admin.where(gender: nil)
               .update_all(gender: User.genders.values.first)
  end

  def down
    User::Admin.update_all(gender: nil)
  end
end
