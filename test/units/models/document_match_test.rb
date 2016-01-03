require "test_helper"

class DocumentMatchTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  test "#create_from! does not create a match when there is no matching fingerprints" do
    document1 = documents(:platypus)
    document2 = documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[0, 4321], [1, 8765]]

    assert_no_difference("DocumentMatch.count", "Match.count") do
      DocumentMatch.create_from!(document1, document2)
    end
  end

  test "#create_from! create a match when there is matching fingerprints" do
    document1 = documents(:platypus)
    document2 = documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[9, 1234], [1, 8765]]

    assert_difference("DocumentMatch.count", 2) do
      assert_difference("Match.count") do
        DocumentMatch.create_from!(document1, document2)
      end
    end
  end

  test "#relevant_matches return the matches for the compared document" do
    reference = documents(:platypus)
    DocumentMatch.destroy_all
    Match.destroy_all

    match1 = Match.create!(fingerprints: [1234, 5678, 0000])
    match2 = Match.create!(fingerprints: [1234, 5678])

    DocumentMatch.create!(
      reference_document: reference,
      compared_document: documents(:fraudulent_platypus),
      match: match1,
    )
    DocumentMatch.create!(
      reference_document: reference,
      compared_document: documents(:fraudulent_bragging),
      match: match2,
    )

    relevant_matches = DocumentMatch.relevant_matches(reference)
    assert_equal 2, relevant_matches.size
    assert_equal documents(:fraudulent_platypus).id,
      relevant_matches.first.compared_document_id
    assert_equal documents(:fraudulent_bragging).id,
      relevant_matches.second.compared_document_id
    assert relevant_matches.all? { |m| m.reference_document_id == reference.id }
  end
end
