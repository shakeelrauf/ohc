# frozen_string_literal: true

def admin_login(admin = nil)
  admin ||= create(:super_admin)

  session[:admin_id] = admin.id
  session[:authentication_token] = admin.authentication.ensure_web_token!
end
