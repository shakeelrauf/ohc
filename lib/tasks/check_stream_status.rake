# frozen_string_literal: true

namespace :ohc do
  desc 'Check for log running streams and stop them'
  task check_stream_status: :environment do
    WARNING_DURATION = Rails.application.secrets.stream_warning_duration
    SHUTDOWN_DURATION = Rails.application.secrets.stream_shutdown_duration

    Stream.find_each do |stream|
      # Ignore the stream unless its running
      next unless stream.channel.state == 'RUNNING'

      event = stream.event

      # Handle case where stream may have been orphaned.  This should never happen.
      unless event
        stream.stop!

        Airbrake.notify('Orphaned stream was found', params: stream.attributes)

        next
      end

      duration = ((Time.zone.now - event.started_at) / 60).to_i

      puts "#{event.name} has been running #{duration} minutes"

      if duration > SHUTDOWN_DURATION
        puts 'Stopping'
        EventMailer.stopped(event, duration).deliver_now

        event.stop!
      elsif duration > WARNING_DURATION
        puts 'Sending Warning'
        EventMailer.warning(event, duration).deliver_now
      end
    end
  end
end
