# frozen_string_literal: true

class Import
  class FindOrCreateUser
    def initialize(row, tenant)
      @row = row
      @tenant = tenant
    end

    def execute
      return child if child.persisted?
      return admin if admin.present?

      Interactions::Users::Creation.new(child).execute

      child
    end

    private

    def child
      @child ||= User::Child.find_or_initialize_by(email: @row.email,
                                                   date_of_birth: @row.date_of_birth&.to_date,
                                                   first_name: @row.first_name,
                                                   last_name: @row.last_name,
                                                   gender: @row.gender&.downcase,
                                                   tenant_id: @tenant.id)
    end

    def admin
      @admin ||= User::Admin.find_by(email: @row.email,
                                     tenant_id: @tenant.id)
    end
  end
end
