require 'test_helper'

class SubmissionsTest < ActionDispatch::IntegrationTest
  test 'create a submission with a sanitizable document' do
    @file = fixture_file_upload('files/documents/file/605975483/platypus1.txt')

    post '/submissions', submission: { documents_attributes: [{ file_ptr: @file }] }
    @submission = Submission.last
    @document = @submission.documents.first

    assert_equal 1, @submission.documents.size
    assert_redirected_to @submission

    assert_not_empty @document.fingerprints
    assert_not_empty @document.indexes
    assert @document.fingerprinted?
    assert @document.sanitized?
  end

  test 'create a submission with an unsanitizable document' do
    @file = fixture_file_upload('files/documents/file/605975485/platypus.jpg')

    post '/submissions', submission: { documents_attributes: [{ file_ptr: @file }] }
    @submission = Submission.last
    @document = @submission.documents.first

    assert_equal 1, @submission.documents.size
    assert_redirected_to @submission

    assert_empty @document.fingerprints
    assert_empty @document.indexes
    refute @document.fingerprinted?
    refute @document.sanitized?
  end

  test 'create a submission with documents of both types' do
    @file1 = fixture_file_upload('files/documents/file/605975485/platypus.jpg')
    @file2 = fixture_file_upload('files/documents/file/605975483/platypus1.txt')

    post '/submissions', submission: {
      documents_attributes: [
        { file_ptr: @file2 },
        { file_ptr: @file1 }
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
