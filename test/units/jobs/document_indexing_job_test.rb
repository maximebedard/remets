require "test_helper"

class DocumentIndexingJobTest < ActiveSupport::TestCase
  include Remets::MockAmazonS3
  self.use_transactional_tests = true

  test "#perform does nothing when no documents are fingerprinted" do
    assert_no_difference("DocumentMatch.count", "Match.count") do
      DocumentIndexingJob.perform_now(submitted_documents(:platypus))
    end
  end

  test "#perform add a match with the intersection of fingerprints" do
    [SubmittedDocument, DocumentMatch, Match].each(&:destroy_all)

    reference = submissions(:log121_lab1_1).submitted_documents.create!(
      file_ptr: @empty_file,
      windows: [[0, 1234], [1, 9876], [4, 5678]],
    )
    compared = submissions(:log121_lab1_2).submitted_documents.create!(
      file_ptr: @empty_file,
      windows: [[0, 1234], [1, 3456], [4, 6666]],
    )

    assert_difference("DocumentMatch.count", 2) do
      assert_difference("Match.count", 1) do
        DocumentIndexingJob.perform_now(reference)
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
    [SubmittedDocument, DocumentMatch, Match].each(&:destroy_all)

    reference = submissions(:log121_lab1_1).submitted_documents.create!(
      file_ptr: @empty_file,
      windows: [[0, 1234], [1, 9876], [4, 5678]],
    )
    _compared = submissions(:log121_lab1_2).submitted_documents.create!(
      file_ptr: @empty_file,
      windows: [[0, 4321], [1, 3456], [4, 6666]],
    )

    assert_no_difference("DocumentMatch.count", "Match.count") do
      DocumentIndexingJob.perform_now(reference)
    end
  end

  test "#perform delete previous matches" do
    DocumentMatch.create!(
      reference_document: submitted_documents(:platypus),
      compared_document: submitted_documents(:fraudulent_platypus),
      match: Match.create!(fingerprints: [1234, 4567]),
      similarity: 0.5,
    )

    SubmittedDocument.stubs(:all_fingerprinted_except).returns(SubmittedDocument.none)

    assert_difference("DocumentMatch.count", -1) do
      DocumentIndexingJob.perform_now(submitted_documents(:platypus))
    end
  end
end
