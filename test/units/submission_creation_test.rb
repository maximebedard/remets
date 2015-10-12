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

  test '#perform fingerprints the document content' do
    submission = @service.perform
    document = submission.documents.first

    assert_not_empty document.indexes
    assert_not_empty document.fingerprints
  end
end
