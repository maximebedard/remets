require "test_helper"

class SubmissionsTest < ActionDispatch::IntegrationTest
  include Remets::SanitizedDocumentFileUploadHelper

  setup do
    sign_in
  end

  test "create a submission with a sanitizable document" do
    @file = sanitizable_file_upload

    submit(
      documents_attributes: [
        { file_ptr: @file },
      ],
    )

    @document = @submission.documents.first

    assert_equal 1, @submission.documents.size
    assert_redirected_to @submission

    assert_not_empty @document.fingerprints
    assert_not_empty @document.indexes
    assert @document.fingerprinted?
    assert @document.sanitized?
  end

  test "create a submission with an unsanitizable document" do
    @file = unsanitizable_file_upload

    submit(
      documents_attributes: [
        { file_ptr: @file },
      ],
    )

    @document = @submission.documents.first

    assert_equal 1, @submission.documents.size
    assert_redirected_to @submission

    assert_empty @document.fingerprints
    assert_empty @document.indexes
    refute @document.fingerprinted?
    refute @document.sanitized?
  end

  test "create a submission with a sanitizable and an unsanitizable documents" do
    @file1 = unsanitizable_file_upload
    @file2 = sanitizable_file_upload

    submit(
      documents_attributes: [
        { file_ptr: @file1 },
        { file_ptr: @file2 },
      ],
    )

    @document1 = @submission.documents.first
    @document2 = @submission.documents.second

    assert_redirected_to @submission

    assert_empty @document1.fingerprints
    assert_empty @document1.indexes
    refute @document1.fingerprinted?
    refute @document1.sanitized?

    assert_not_empty @document2.fingerprints
    assert_not_empty @document2.indexes
    assert @document2.fingerprinted?
    assert @document2.sanitized?
  end

  private

  def submit(submission_params = {})
    perform_enqueued_jobs do
      post "/handovers/#{handovers(:log121_lab1).uuid}/submissions",
        submission: submission_params

      @submission = Submission.last
    end
  end
end
