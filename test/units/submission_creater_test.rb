require 'test_helper'

class SubmissionCreaterTest < ActiveSupport::TestCase
  setup do
    @fixture = fixture_file_upload('files/documents/file/605975481/text_document1.txt')
    @service = SubmissionCreater.new(
      documents_attributes: [{ file_ptr: @fixture }]
    )
  end

  test '#perform creates a new submission' do
    assert_difference ['Submission.count', 'Document.count'] do
      @service.perform
    end
  end

  test '#perform fingerprints the document content' do
    submission = @service.perform.reload
    document = submission.documents.first

    assert_not_empty document.windows
  end
end
