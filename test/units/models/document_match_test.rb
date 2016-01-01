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

    assert_difference("DocumentMatch.count") do
      DocumentMatch.create_from!(document1, document2)
    end
  end

  test "#relevant_matches return the matches for the compared document" do
    reference = documents(:platypus)
    DocumentMatch.destroy_all
    DocumentMatch.create(
      reference_document: reference,
      compared_document: documents(:fraudulent_platypus),
      fingerprints: [1234, 5678, 0000],
    )
    DocumentMatch.create(
      reference_document: reference,
      compared_document: documents(:fraudulent_bragging),
      fingerprints: [1234, 5678],
    )
    DocumentMatch.create(
      reference_document: reference,
      compared_document: documents(:empty),
    )

    assert_equal 2, DocumentMatch.relevant_matches(reference).size
  end
end
