require 'test_helper'

class SubmissionCreationTest < ActiveSupport::TestCase
  setup do
    @fixture = fixture_file_upload('files/documents/file/605975481/text_document1.txt')
    @service = SubmissionCreation.new(
      documents_attributes: [
        @fixture
      ]
    )
  end

  test '#perform creates a new submission' do
    assert_difference ['Submission.count', 'Document.count'] do
      @service.perform
    end
  end

  test '#perform add shingles to the sumbission' do
    submission = @service.perform
    assert_equal \
      [254149830, 156990633, 49670451, 124562433].sort,
      submission.documents.first.shingles.sort
  end
end
