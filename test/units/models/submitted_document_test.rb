require "test_helper"

class SubmittedDocumentTest < ActiveSupport::TestCase
  include Remets::MockAmazonS3

  setup do
    @submitted_document = submitted_documents(:platypus)
  end

  test "#file" do
    assert_equal "submitted_documents/platypus1.txt",
      @submitted_document.file.key
  end

  test "#file exists" do
    assert @submitted_document.file.exists?
  end

  test "#sanitized_file" do
    assert_equal "sanitized/submitted_documents/platypus1.txt",
      @submitted_document.sanitized_file.key
  end

  test "#sanitized_file exists" do
    assert @submitted_document.sanitized_file.exists?
  end

  test "#fingerprinted? when fingerprinted_at is not present" do
    assert_equal false, @submitted_document.fingerprinted?
  end

  test "#fingerprinted? when fingerprinted_at is present" do
    @submitted_document.fingerprinted_at = Time.zone.now
    assert_equal true, @submitted_document.fingerprinted?
  end

  test "#windows" do
    @submitted_document.indexes = [1, 2, 3]
    @submitted_document.fingerprints = [4, 5, 6]
    assert_equal [[1, 4], [2, 5], [3, 6]], @submitted_document.windows
  end

  test "#windows=" do
    @submitted_document.windows = [[1, 4], [2, 5], [3, 6]]
    assert_equal [1, 2, 3], @submitted_document.indexes
    assert_equal [4, 5, 6], @submitted_document.fingerprints
  end
end
