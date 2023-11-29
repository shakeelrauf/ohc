# frozen_string_literal: true

namespace :ohc do
  desc 'Create an initial media store container on AWS'
  task create_media_store_container: :environment do
    name = ENV['CONTAINER_NAME']

    raise 'CONTAINER_NAME must be specified' unless name.present?

    logger = Logger.new(STDOUT)

    container_request = Streaming::CreateMediaStoreContainer.new(name, logger).execute

    puts "Container Endpoint: #{container_request.container.endpoint}"
  end
end
