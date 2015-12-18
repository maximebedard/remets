require "test_helper"

class SubmissionsTest < ActionDispatch::IntegrationTest
  include Remets::DocumentFileUploadHelper

  test "create a submission with a sanitizable document" do
    @file = sanitizable_file_upload

    post "/submissions", submission: { documents_attributes: [{ file_ptr: @file }] }
    @submission = Submission.last
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

    post "/submissions", submission: { documents_attributes: [{ file_ptr: @file }] }
    @submission = Submission.last
    @document = @submission.documents.first

    assert_equal 1, @submission.documents.size
    assert_redirected_to @submission

    assert_empty @document.fingerprints
    assert_empty @document.indexes
    refute @document.fingerprinted?
    refute @document.sanitized?
  end

  test "create a submission with documents of both types" do
    @file1 = unsanitizable_file_upload
    @file2 = sanitizable_file_upload

    post "/submissions", submission: {
      documents_attributes: [
        { file_ptr: @file2 },
        { file_ptr: @file1 },
      ]
    }
    @submission = Submission.last
    @document1, @document2 = @submission.documents

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
end
