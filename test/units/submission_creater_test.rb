require "test_helper"

class SubmissionCreaterTest < ActiveSupport::TestCase
  include Remets::DocumentFileUploadHelper

  test "#perform creates a submission with a single document" do
    assert_difference(["Submission.count", "Document.count"]) do
      perform(files: [sanitizable_file_upload])
    end
  end

  test "#perform fingerprints a single document content" do
    assert_enqueued_jobs(1) do
      perform(files: [sanitizable_file_upload])
    end
  end

  test "#perform creates a submission with multiple documents" do
    assert_difference("Submission.count") do
      assert_difference("Document.count", 2) do
        perform(files: [sanitizable_file_upload] * 2)
      end
    end
  end

  test "#perform fingerprints multiple documents content" do
    assert_enqueued_jobs(2) do
      perform(files: [sanitizable_file_upload] * 2)
    end
  end

  private

  def perform(files: [])
    SubmissionCreater.new(
      documents_attributes: files.map { |f| { file_ptr: f } },
    ).perform
  end
end
