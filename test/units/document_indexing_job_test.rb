require "test_helper"

class DocumentIndexingJobTest < ActiveSupport::TestCase
  test "#perform add matches for n-1 documents fingerprinted" do
    Document.update_all(fingerprints: [1234])
    assert_difference("DocumentMatch.count", Document.count - 1) do
      DocumentIndexingJob.perform_now(documents(:platypus).id)
    end
  end

  test "#perform does nothing when no documents are fingerprinted" do
    assert_no_difference("DocumentMatch.count") do
      DocumentIndexingJob.perform_now(documents(:platypus).id)
    end
  end

  test "#perform add a match with the intersection of fingerprints" do
  end

  test "#perform raises when the document no longer exists" do
    assert_raises ActiveRecord::RecordNotFound do
      DocumentIndexingJob.perform_now(1337)
    end
  end
end
