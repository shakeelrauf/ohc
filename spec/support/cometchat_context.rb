# frozen_string_literal: true

# OPTIMIZE: This file has reached a state where it needs refactoring.

require 'rails_helper'

RSpec.shared_context 'with cometchat calls', shared_context: :metadata do
  let(:new_auth_token) { 'NEW_AUTH_TOKEN' }
  let(:invalid_user_id) { -1 }
  let(:invalid_user_name) { 'INVALID USER' }

  let(:user_uid_already_in_group) { 'USER_UID_ALREADY_IN_GROUP' }
  let(:user_uid_not_in_group) { 'USER_UID_NOT_IN_GROUP' }

  let(:invalid_group_id) { 'INVALID_GROUP_ID' }
  let(:valid_group_id) { 'VALID_GROUP_ID' }

  let(:invalid_message_uid) { '-1' }

  let(:conversation_id) { rand(1000) }
  let(:conversation_with_user) { create(:admin) }

  before do
    # NOTE: These don't really need to be before each,
    # but RSpec doesn't allow doubles outside of the per-test lifecycle.
    allow(Cometchat::AuthToken).to receive(:create) { OpenStruct.new(uid: 'UID', auth_token: new_auth_token) }
    allow(Cometchat::AuthToken).to receive(:create).with(invalid_user_id) { raise Cometchat::ResponseError }
    allow(Cometchat::Group).to receive(:create) { OpenStruct.new(guid: 'GROUP_GUID') }
    allow(Cometchat::Group).to receive(:add_members) do |group_guid, params|
      user_group_role, user_uid_array = params.first
      user_uid = user_uid_array.first

      response_hash = if group_guid == invalid_group_id
                        { user_uid => { 'success' => false, 'error' => { 'code' => 'GROUP_NOT_FOUND' } } }
                      elsif user_uid == user_uid_already_in_group
                        { user_uid => { 'success' => false, 'error' => { 'code' => 'ERR_SAME_SCOPE' } } }
                      else
                        { user_uid => { 'success' => true } }
                      end

      OpenStruct.new(user_group_role => response_hash)
    end

    allow(Cometchat::User).to receive(:create) { OpenStruct.new(uid: 'NEW_UID', auth_token: 'AUTH_TOKEN') }
    allow(Cometchat::User).to receive(:create).with(hash_including(name: invalid_user_name)) do
      raise Cometchat::UidAlreadyExists.new(body: '{}', code: 500, url: 'http://cometchat.api')
    end

    allow(Cometchat::Message).to receive(:delete) do |user_uid, message_uid|
      if message_uid == invalid_message_uid
        raise Cometchat::ResponseError.new(code: 404,
                                           body: { message: 'Not found' },
                                           url: "users/#{user_uid}/messages/#{message_uid}")
      end

      OpenStruct.new(type: 'message')
    end

    allow(Cometchat::Conversation).to receive(:all) do |_chat_uid, params|
      [OpenStruct.new(conversation_id: conversation_id,
                      conversation_type: params[:conversation_type],
                      created_at: 1.hour.ago.strftime('%Y%m%d'),
                      updated_at: 30.minutes.ago.strftime('%Y%m%d'),
                      unread_message_count: 1,
                      conversation_with: {
                        'uid' => conversation_with_user.chat_uid
                      })]
    end
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'with cometchat calls', include_shared: true
end
