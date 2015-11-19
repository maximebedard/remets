require 'test_helper'

class SubmissionsTest < ActionDispatch::IntegrationTest
  test 'Create a submission with a sanitizable document' do
    @file = fixture_file_upload('files/documents/file/605975481/text_document1.txt')

    post '/submissions', submission: { documents_attributes: [@file] }

    assert_equal 1, 2
  end

  test 'Create a submission with an unsanitizable document'
  test 'Create a submission with documents of both types'
end
