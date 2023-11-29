# frozen_string_literal: true

require 'fcm'

module Firebase
  class Notification
    ITERATION_COUNT = 1000

    def initialize(tokens: [], title:, body:, data: {})
      @tokens = tokens
      @title = title
      @body = body
      @data = data
    end

    def execute
      @tokens.each_slice(ITERATION_COUNT) do |tokens_slice|
        client.send(tokens_slice, options)
      end
    end

    private

    def firebase_key
      Rails.application.secrets.firebase[:server_key]
    end

    def client
      @client ||= FCM.new(firebase_key)
    end

    def options
      {
        priority: 'high',
        data: @data,
        notification: {
          body: @body,
          title: @title
        }
      }
    end
  end
end
