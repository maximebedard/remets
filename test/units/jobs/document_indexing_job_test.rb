require "test_helper"

class DocumentIndexingJobTest < ActiveSupport::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  self.use_transactional_fixtures = true

  test "#perform add document matches for (n - 1) * 2 documents fingerprinted" do
    Document.update_all(fingerprints: [1234])
    assert_difference("DocumentMatch.count", (Document.count - 1) * 2) do
      assert_difference("Match.count", Document.count - 1) do
        DocumentIndexingJob.perform_now(documents(:platypus).id)
      end
    end
  end

  test "#perform does nothing when no documents are fingerprinted" do
    assert_no_difference("DocumentMatch.count", "Match.count") do
      DocumentIndexingJob.perform_now(documents(:platypus).id)
    end
  end

  test "#perform add a match with the intersection of fingerprints" do
    [Document, DocumentMatch, Match].each(&:destroy_all)

    reference = Document.create!(file_ptr: empty_file_upload, windows: [[0, 1234], [1, 9876], [4, 5678]])
    compared = Document.create!(file_ptr: empty_file_upload, windows: [[0, 1234], [1, 3456], [4, 6666]])

    assert_difference("DocumentMatch.count", 2) do
      assert_difference("Match.count", 1) do
        DocumentIndexingJob.perform_now(reference.id)
      end
    end

    match = Match.first
    document_match1 = DocumentMatch.first
    document_match2 = DocumentMatch.second

    assert_equal [1234], match.fingerprints

    assert_equal document_match1.match, document_match1.match
    assert_equal reference, document_match1.reference_document
    assert_equal compared, document_match1.compared_document

    assert_equal document_match2.match, document_match2.match
    assert_equal compared, document_match2.reference_document
    assert_equal reference, document_match2.compared_document
  end

  test "#perform does not add a match when the intersection is empty" do
    Document.destroy_all
    reference = Document.create!(file_ptr: empty_file_upload, windows: [[0, 1234], [1, 9876], [4, 5678]])
    Document.create!(file_ptr: empty_file_upload, windows: [[0, 4321], [1, 3456], [4, 6666]])

    assert_no_difference("DocumentMatch.count", "Match.count") do
      DocumentIndexingJob.perform_now(reference.id)
    end
  end

  test "#perform raises when the document no longer exists" do
    assert_raises ActiveRecord::RecordNotFound do
      DocumentIndexingJob.perform_now(1337)
    end
  end
end
