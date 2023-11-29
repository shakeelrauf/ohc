# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Users::SessionsController, type: :controller do
  let(:valid_admin) { create(:admin) }

  describe 'POST #create' do
    let(:example_request) { post :create, params: { user_admin: params } }
    let(:params) { { email: valid_admin.email, password: valid_admin.authentication.password } }

    it 'does not change the cometchat auth token' do
      expect { example_request }.not_to change(valid_admin, :chat_auth_token)
    end

    context 'with valid details' do
      before do
        example_request
      end

      it 'redirects the admin to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the admin a valid web session token' do
        expect(valid_admin.authentication.web_session_token.token).not_to be_nil
      end
    end

    context 'with invalid details' do
      before do
        post :create, params: { user_admin: { email: 'invalid', password: 'password' } }
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'sets the appropriate error message' do
        error_string = I18n.t('admins.sessions.fail')

        expect(assigns(:admin).errors['base'].first).to eq(error_string)
      end

      it 'doesnt generate the admin a web session token' do
        expect(valid_admin.authentication.web_session_token&.token).to be_nil
      end
    end
  end

  describe 'delete #destroy' do
    context 'when successful' do
      before do
        admin_login

        delete :destroy
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'nullifys the admins web session token' do
        expect(valid_admin.authentication.web_session_token).to be_nil
      end

      it 'removes admin_id from the admins session' do
        expect(session[:admin_id]).to be_nil
      end

      it 'removes authentication_token from the admins session' do
        expect(session[:authentication_token]).to be_nil
      end
    end

    it 'does not error when admin is not logged in' do
      delete :destroy

      expect(response).to redirect_to(root_path)
    end
  end
end
