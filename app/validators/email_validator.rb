# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  # Simple regex inspired by http://davidcel.is/blog/2012/09/06/stop-validating-email-addresses-with-regex/

  def validate_each(record, attribute, value)
    return unless value.present? && value !~ /.+@.+\..+/i

    record.errors.add(attribute, :invalid)
  end
end
