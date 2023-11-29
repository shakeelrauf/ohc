# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
mycamp_theme = ColorTheme.find_or_create_by(name: 'MyCamp', primary_color: '#9067B7', secondary_color: '#F9E2D3', app_layout: 'my_camp')
color_theme_1 = ColorTheme.find_or_create_by(name: 'Theme 1', primary_color: '#5C5590', secondary_color: '#5C5590', app_layout: 'faith_spark')
color_theme_2 = ColorTheme.find_or_create_by(name: 'Theme 2', primary_color: '#348998', secondary_color: '#348998', app_layout: 'faith_spark')
color_theme_3 = ColorTheme.find_or_create_by(name: 'Theme 3', primary_color: '#305E9D', secondary_color: '#305E9D', app_layout: 'faith_spark')
color_theme_4 = ColorTheme.find_or_create_by(name: 'Theme 4', primary_color: '#F28314', secondary_color: '#F28314', app_layout: 'faith_spark')
color_theme_5 = ColorTheme.find_or_create_by(name: 'Theme 5', primary_color: '#7B9D30', secondary_color: '#7B9D30', app_layout: 'faith_spark')
color_theme_6 = ColorTheme.find_or_create_by(name: 'Theme 6', primary_color: '#305E9D', secondary_color: '#FC7EB9', app_layout: 'faith_spark')
color_theme_7 = ColorTheme.find_or_create_by(name: 'Theme 7', primary_color: '#C6475B', secondary_color: '#FFB367', app_layout: 'faith_spark')

tenant = Tenant.find_or_initialize_by(name: 'One Hope Canada')
tenant.update(color_theme: mycamp_theme)

Setting.create_with(value: Rails.application.secrets.email[:alert_address], visible: false).find_or_create_by!(name: 'Alert Email')
Setting.create_with(value: Rails.application.secrets.email[:contact_address], visible: false).find_or_create_by!(name: 'Contact Email')
Setting.create_with(value: Rails.application.secrets.training_manual_url, visible: false).find_or_create_by!(name: 'Training Manual URL')
Setting.create_with(value: Rails.application.secrets.cometchat[:app_id], visible: true).find_or_create_by!(name: 'Cometchat App ID')
Setting.create_with(value: Rails.application.secrets.cometchat[:region], visible: true).find_or_create_by!(name: 'Cometchat Region')
Setting.create_with(value: Rails.application.secrets.minimum_app_version, visible: true).find_or_create_by!(name: Rails.application.secrets.minimum_app_version_setting_name)

admin_attributes = {
  role: 'tenant_admin',
  email: 'admin@dubitlimited.com',
  first_name: 'Admin',
  last_name: 'User',
  gender: 'male',
  tenant_id: tenant.id
}

if !User::Admin.exists?(email: admin_attributes[:email]) && Rails.env.development?
  admin_user = User::Admin.new(admin_attributes)

  raise ActiveRecord::RecordInvalid unless Interactions::Users::Creation.new(admin_user).execute

  if admin_user.authentication.blank?
    Authentication.create(username: 'admin.user',
                          password: 'Password1',
                          password_confirmation: 'Password1',
                          users: [admin_user])
  end
end
