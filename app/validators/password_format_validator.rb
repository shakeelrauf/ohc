# frozen_string_literal: true

class PasswordFormatValidator < ActiveModel::EachValidator
  CONTAINS_DIGIT = /\A(?=.*\d)/x.freeze # Must contain a digit
  CONTAINS_LC_CHARACTER = /\A(?=.*[a-z])/x.freeze # Must contain a lower case character
  CONTAINS_UC_CHARACTER = /\A(?=.*[A-Z])/x.freeze # Must contain an upper case character

  def validate_each(record, attribute, value)
    @record = record
    @attribute = attribute
    @value = value

    # Don't validate if the password is blank
    return if value.blank?

    test_against(CONTAINS_DIGIT, :must_contain_digit)
    test_against(CONTAINS_LC_CHARACTER, :must_contain_lc_character)
    test_against(CONTAINS_UC_CHARACTER, :must_contain_uc_character)
  end

  private

  def test_against(regex, error)
    add_error(error) unless regex.match?(@value)
  end

  def add_error(error)
    @record.errors.add(@attribute, error)
  end
end
