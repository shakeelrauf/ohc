# frozen_string_literal: true

require 'rails_helper'

shared_examples 'requires an authenticated user' do
  it 'redirects when not logged in' do
    session[:admin_id] = -1
    expect(request_example).to redirect_to(login_path)
  end
end
