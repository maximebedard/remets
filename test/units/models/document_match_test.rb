require "test_helper"

class DocumentMatchTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  test "#create_from! does not create a match when there is no matching fingerprints" do
    document1 = documents(:platypus)
    document2 = documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[0, 4321], [1, 8765]]

    assert_no_difference("DocumentMatch.count") do
      DocumentMatch.create_from!(document1, document2)
    end
  end

  test "#create_from! create a match when there is matching fingerprints" do
    document1 = documents(:platypus)
    document2 = documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[9, 1234], [1, 8765]]

    assert_difference("DocumentMatch.count", 2) do
      DocumentMatch.create_from!(document1, document2)
    end
  end

  test "#relevant_matches return the matches for the compared document" do
    DocumentMatch.destroy_all

    reference = documents(:platypus)
    reference.update!(fingerprints: [1234, 5678, 0000])

    compared1 = documents(:fraudulent_platypus)
    compared1.update!(fingerprints: [1234, 5678])

    compared2 = documents(:fraudulent_bragging)
    compared2.update!(fingerprints: [0000])

    DocumentMatch.create_from!(reference, compared1)
    DocumentMatch.create_from!(reference, compared2)

    relevant_matches = DocumentMatch.relevant_matches(reference)
    assert_equal 2, relevant_matches.size
    assert_equal compared1.id,
      relevant_matches.first.compared_document_id
    assert_equal compared2.id,
      relevant_matches.second.compared_document_id
    assert relevant_matches.all? { |m| m.reference_document_id == reference.id }
  end

  test "#similarity" do
    document1 = documents(:platypus)
    document2 = documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[9, 1234], [1, 8765], [12, 4444]]

    match1, match2 = DocumentMatch.create_from!(document1, document2)

    assert_in_delta 0.3333, match1.similarity
    assert_in_delta 0.5, match2.similarity
  end
end
