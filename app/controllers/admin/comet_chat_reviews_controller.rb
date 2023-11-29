# frozen_string_literal: true

require 'faraday'

module Admin
  class CometChatReviewsController < ApplicationController
    def index
      authorize! :show, :comet_chat_review

      @data = Cometchat::Global::Message.all(query_params).data.reverse
    end

    private

    def allowed_query_params
      params.permit(:conversation_id, :limit, :from_timestamp, :to_timestamp)
    end

    def query_params
      allowed_query_params.to_h.each_with_object({}) do |(key, value), santised_params|
        # @note Time values must be transformed to integers for CometChat API
        santised_params[key] = 
          if %i[from_timestamp to_timestamp].include?(key.to_sym) 
            value&.to_date&.to_time&.to_i
          else
            value
          end
      end
    end
  end
end
