require "test_helper"

class SubmissionCreaterTest < ActiveSupport::TestCase
  include Remets::DocumentFileUploadHelper

  setup do
    @fixture = sanitizable_file_upload
    @service = SubmissionCreater.new(
      documents_attributes: [{ file_ptr: @fixture }],
    )
  end

  test "#perform creates a submission with a single document" do
    assert_difference ["Submission.count", "Document.count"] do
      @service.perform
    end
  end

  test "#perform creates a submission with multiple documents"

  test "#perform fingerprints a single document content" do
    submission = @service.perform.reload
    document = submission.documents.first

    assert_not_empty document.windows
  end

  test "#perform fingerprints multiple documents content"
end
