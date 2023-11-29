# frozen_string_literal: true

class TenantDecorator < BaseDecorator
  def max_users_label
    "#{users.count}/#{max_users}"
  end

  def max_streams_label
    "#{streams.count}/#{max_streams}"
  end

  def max_stream_hours_label
    "#{number_with_precision(total_duration_in_hours, precision: 2)}/#{number_with_precision(max_stream_hours, precision: 2)}"
  end
end
