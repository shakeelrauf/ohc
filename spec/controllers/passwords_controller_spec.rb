# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  let(:child) { create(:child) }
  let(:authentication) { child.authentication }
  let(:new_password) { 'NewPassword1' }
  let(:bad_token) { 'abcdefg' }
  let(:bad_password) { '' }

  before do
    authentication.ensure_reset_token!
  end

  describe 'GET #new' do
    it 'succeeds with valid email' do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid email' do
      let(:example_request) { post :create, params: { user: { email: child.email } } }

      before do |example|
        example_request unless example.metadata[:skip_request].present?
      end

      it 'renders the create template' do
        expect(response).to render_template(:create)
      end

      it 'queues an email to be sent', skip_request: true do
        expect { example_request }.to(have_enqueued_job.on_queue('mailers'))
      end
    end

    context 'with account with multiple children' do
      let(:email) { 'child@example.com' }
      let!(:children) { create_list(:child, 2, email: email) }
      let(:example_request) { post :create, params: { user: { email: email } } }

      before do |example|
        example_request unless example.metadata[:skip_request].present?
      end

      it 'renders the create template' do
        expect(response).to render_template(:create)
      end

      it 'queues an email to be sent', skip_request: true do
        expect { example_request }.to(have_enqueued_job.on_queue('mailers'))
      end
    end

    # To stop the ability to enumerate email addresses the password reset
    # facility always returns a 201 and a ambiguous message.
    context 'with invalid email' do
      before do
        post :create, params: { user: { email: 'test@example.com' } }
      end

      it 'renders the create template' do
        expect(response).to render_template(:create)
      end
    end
  end

  describe 'GET #edit' do
    it 'succeeds with valid id and reset token' do
      get :edit, params: { id: authentication.id,
                           reset_token: authentication.password_reset_token.token }

      expect(response).to render_template(:edit)
    end

    context 'when reset token is invalid' do
      before do
        get :edit, params: { id: authentication.id,
                             reset_token: bad_token }
      end

      it 'redirects to unrecognised details path' do
        expect(response).to redirect_to(unrecognised_passwords_path)
      end
    end

    context 'when reset token is blank' do
      before do
        get :edit, params: { id: authentication.id,
                             reset_token: '' }
      end

      it 'redirects to unrecognised details path' do
        expect(response).to redirect_to(unrecognised_passwords_path)
      end
    end

    context 'when reset token is nil' do
      before do
        get :edit, params: { id: authentication.id,
                             reset_token: nil }
      end

      it 'redirects to unrecognised details path' do
        expect(response).to redirect_to(unrecognised_passwords_path)
      end
    end
  end

  describe 'PUT #update' do
    context 'when successful updates the authentications password then' do
      before do
        put :update, params: { id: authentication.id,
                               reset_token: authentication.password_reset_token.token,
                               authentication: {
                                 password: new_password,
                                 password_confirmation: new_password
                               } }
      end

      it 'redirects to updated path' do
        expect(response).to redirect_to(updated_passwords_path)
      end

      it 'nullifys the authentications password reset token record' do
        expect(authentication.reload.password_reset_token).to be_nil
      end
    end

    context 'when reset token is invalid' do
      before do
        put :update, params: { id: authentication.id,
                               reset_token: bad_token,
                               authentication: {
                                 password: new_password,
                                 password_confirmation: new_password
                               } }
      end

      it 'redirects to unrecognised details path' do
        expect(response).to redirect_to(unrecognised_passwords_path)
      end
    end

    context 'when reset token is blank' do
      before do
        put :update, params: { id: authentication.id,
                               reset_token: '',
                               authentication: {
                                 password: new_password,
                                 password_confirmation: new_password
                               } }
      end

      it 'redirects to unrecognised details path' do
        expect(response).to redirect_to(unrecognised_passwords_path)
      end
    end

    context 'when reset token is nil' do
      before do
        put :update, params: { id: authentication.id,
                               reset_token: '',
                               authentication: {
                                 password: new_password,
                                 password_confirmation: new_password
                               } }
      end

      it 'redirects to unrecognised details path' do
        expect(response).to redirect_to(unrecognised_passwords_path)
      end
    end

    context 'when passwords are mismatched' do
      before do
        put :update, params: { id: authentication.id,
                               reset_token: authentication.password_reset_token.token,
                               authentication: {
                                 password: bad_password,
                                 password_confirmation: bad_password
                               } }
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'doesnt update the authentication saved password' do
        expect(authentication.reload.authenticate(bad_password)).to eq(false)
      end
    end
  end
end
