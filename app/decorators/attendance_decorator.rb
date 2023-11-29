# frozen_string_literal: true

class AttendanceDecorator < BaseDecorator
  def formatted_code
    code.chars.each_slice(4).map(&:join).join(' ')
  end
end
