# frozen_string_literal: true

require 'forwardable'

class Conversation
  extend Forwardable

  attr_accessor :user
  attr_reader :id, :receiver_type, :conversation_with

  # Forward certain methods directly to the CometChat Conversation object
  def_delegators :@cc_conversation,
                 :created_at,
                 :last_message,
                 :updated_at,
                 :unread_message_count

  def self.all(current_user_chat_uid)
    conversation_type = Cometchat::Conversation::Types::USER
    cc_conversations = Cometchat::Conversation.all(current_user_chat_uid, conversation_type: conversation_type)
    cc_conversations.map { |conversation| from_cometchat(conversation, current_user_chat_uid) }.compact
  end

  def self.from_cometchat(cc_conversation, current_user_chat_uid)
    # Note: This is stupid, but CometChat can sometimes report that you're in a conversation with yourself.
    return if cc_conversation.conversation_with&.dig('uid') == current_user_chat_uid

    new(cc_conversation: cc_conversation)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # Required for serializer
  def conversation_with_id
    @conversation_with&.id
  end

  private

  def initialize(cc_conversation:)
    @cc_conversation = cc_conversation
    @id = cc_conversation.conversation_id
    @receiver_type = cc_conversation.conversation_type
    @conversation_with = case receiver_type
                         when Cometchat::Conversation::Types::GROUP
                           # TODO: Handle receiver_type GROUP
                         when Cometchat::Conversation::Types::USER
                           retrieve_conversation_with_user(cc_conversation.conversation_with['uid'])
                         end
  end

  def retrieve_conversation_with_user(chat_uid)
    User.find_by!(chat_uid: chat_uid)
  end
end
