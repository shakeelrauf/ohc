# frozen_string_literal: true

module API
  module V2
    module Users
      class ConversationsController < BaseController
        # == [GET] /api/v2/users/conversations.json
        # Retrieve the index of this user's one-to-one conversations
        def index
          conversations = Conversation.all(current_user.chat_uid)

          render json: API::V2::ConversationSerializer.new(conversations, serializer_params)
        end
      end
    end
  end
end
