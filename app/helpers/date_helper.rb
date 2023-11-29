# frozen_string_literal: true

module DateHelper
  def formatted_date(date, default: 'Never')
    date.present? ? l(date) : default
  end
end
