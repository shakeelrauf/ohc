# frozen_string_literal: true

require 'aws-sdk-mediastore'

module Streaming
  class CreateMediaStoreContainer
    include Streaming::Credentials

    CREATING_STATUS = 'CREATING'.freeze

    attr_accessor :name, :logger

    def initialize(name, logger = Rails.logger)
      self.name = name
      self.logger = logger
    end

    def execute
      create_container

      log('Waiting for container to become available')

      while describe_container.container.status == CREATING_STATUS
        log('Waiting 10')
        sleep(10)
      end

      put_cors_policy
      put_container_polcy

      describe_container
    end

    def create_container
      client.create_container(
        container_name: name
      )
    end

    def describe_container
      client.describe_container(
        container_name: name
      )
    end

    def put_cors_policy
      client.put_cors_policy(
        container_name: name,
        cors_policy: [
          {
            allowed_origins: ['*'],
            allowed_methods: ['GET'],
            allowed_headers: ['*'],
            max_age_seconds: 3000,
            expose_headers: ['*']
          }
        ]
      )
    end

    def put_container_polcy
      client.put_container_policy(
        container_name: name,
        policy: policy.to_json.to_s
      )
    end

    private

    def client
      @client ||= Aws::MediaStore::Client.new(
        region: region_name,
        credentials: credentials
      )
    end

    def policy
      {
        'Version': '2012-10-17',
        'Statement': [{
          'Sid': 'PublicReadOverHttpOrHttps',
          'Effect': 'Allow',
          'Principal': '*',
          'Action': ['mediastore:GetObject', 'mediastore:DescribeObject'],
          'Resource': "arn:aws:mediastore:#{region_name}:#{account_id}:container/#{name}/*",
          'Condition': {
            'Bool': {
              'aws:SecureTransport': %w[true false]
            }
          }
        }]
      }
    end

    def log(message)
      logger.warn(message)
    end
  end
end
