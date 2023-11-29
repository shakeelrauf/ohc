# frozen_string_literal: true

return if ENV['ENABLE_AWESOME_PRINT'] != 'true'

require 'awesome_print'

AwesomePrint.irb!
