# frozen_string_literal: true

include ActionDispatch::TestProcess

def fixture_file(filename, mime_type)
  fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', filename), mime_type)
end
