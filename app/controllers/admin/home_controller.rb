# frozen_string_literal: true

module Admin
  class HomeController < ApplicationController
    skip_authorization_check

    def index
      if current_tenant.blank?
        redirect_to tenants_path
      elsif current_user.cabin_admin?
        redirect_to events_path(event_type: 'cabin')
      elsif current_user.camp_admin?
        redirect_to camp_location_path(current_user.camp_location)
      else
        redirect_to camp_locations_path
      end
    end
  end
end
