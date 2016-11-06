require "test_helper"

class SubmissionsTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:gaston))
  end

  test "create a submission with a sanitizable document" do
    @file = submitted_documents(:bragging).file_ptr

    submit(
      documents_attributes: [
        { file_ptr: @file },
      ],
    )

    @document = @submission.submitted_documents.first

    assert_equal 1, @submission.submitted_documents.size
    assert_redirected_to @submission

    assert_not_empty @document.fingerprints
    assert_not_empty @document.indexes
    assert @document.fingerprinted?
    assert @document.sanitized?
  end

  test "create a submission with an unsanitizable document" do
    @file = submitted_documents(:platypus_image).file_ptr

    submit(
      documents_attributes: [
        { file_ptr: @file },
      ],
    )

    @document = @submission.submitted_documents.first

    assert_equal 1, @submission.submitted_documents.size
    assert_redirected_to @submission

    assert_empty @document.fingerprints
    assert_empty @document.indexes
    refute @document.fingerprinted?
    refute @document.sanitized?
  end

  test "create a submission with a sanitizable and an unsanitizable documents" do
    @file1 = submitted_documents(:platypus_image).file_ptr
    @file2 = submitted_documents(:bragging).file_ptr

    submit(
      documents_attributes: [
        { file_ptr: @file1 },
        { file_ptr: @file2 },
      ],
    )

    @document1 = @submission.submitted_documents.first
    @document2 = @submission.submitted_documents.second

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
      post "/evaluations/#{evaluations(:log121_lab1).uuid}/submissions", params: { submission: submission_params }

      @submission = Submission.last
    end
  end
end
