# frozen_string_literal: true

module Admin
  class ConversationsController < ApplicationController
    skip_authorization_check

    def index
      users = User::Admin.accessible_by(current_ability, :review)
      all_conversations = users.map { |admin| [admin, Conversation.all(admin.chat_uid)] }

      conversation_ids = []
      @conversations = all_conversations.each_with_object([]) do |(admin, conversations), acc|
        conversations.each do |conversation|
          next if conversation_ids.include?(conversation.id)

          conversation.user = admin
          conversation_ids << conversation.id

          acc << conversation
        end

        acc
      end

      # Sort by Updated At, so most recent messages are first.
      @conversations.sort! { |a, b| b.updated_at <=> a.updated_at }
    end

    def show
      messages_request = Cometchat::Global::Message.all(conversation_id: params[:id], hide_deleted: false)
      @messages = messages_request.data

      conversation_user_entities = messages_request.data.first&.data&.dig('entities')

      raise ActiveRecord::RecordNotFound if conversation_user_entities.blank?

      @conversation_users = fetch_conversation_users(conversation_user_entities)
    end

    private

    def fetch_conversation_users(conversation_users)
      user_1_uid = conversation_users.dig('sender', 'entity', 'uid')
      user_2_uid = conversation_users.dig('receiver', 'entity', 'uid')

      {
        user_1_uid => fetch_conversation_user(user_1_uid),
        user_2_uid => fetch_conversation_user(user_2_uid)
      }
    end

    def fetch_conversation_user(chat_uid)
      User.accessible_by(current_ability, :review).find_by!(chat_uid: chat_uid)
    end
  end
end
