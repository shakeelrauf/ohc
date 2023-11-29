# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PasswordFormatValidator do
  let(:new_password) { 'NewPassword1' }
  let(:authentication) do
    authentication = create(:authentication)
    authentication.password = new_password
    authentication
  end
  let(:validator) { described_class.new(attributes: authentication.attributes) }
  let(:password_errors) { authentication.errors[:password] }

  before do
    validator.validate_each(authentication, :password, new_password)
  end

  describe 'validating a authentication password' do
    context 'with a valid password' do
      it { expect(password_errors.size).to be(0) }
    end

    describe 'with a password that contains no digits' do
      let(:new_password) { 'NewPassword' }

      it { expect(password_errors).to include('must contain a digit') }
    end

    describe 'with a password that has no lowercase characters' do
      let(:new_password) { 'NEWPASSWORD1' }

      it { expect(password_errors).to include('must contain a lowercase character') }
    end

    describe 'with a password that has no uppercase characters' do
      let(:new_password) { 'newpassword1' }

      it { expect(password_errors).to include('must contain an uppercase character') }
    end
  end
end
