require "test_helper"

class DocumentMatchTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  test "#create_from! does not create a match when there is no matching fingerprints" do
    document1 = submitted_documents(:platypus)
    document2 = submitted_documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[0, 4321], [1, 8765]]

    assert_no_difference("DocumentMatch.count") do
      DocumentMatch.create_from!(document1, document2)
    end
  end

  test "#create_from! create a match when there is matching fingerprints" do
    document1 = submitted_documents(:platypus)
    document2 = submitted_documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[9, 1234], [1, 8765]]

    assert_difference("DocumentMatch.count", 2) do
      DocumentMatch.create_from!(document1, document2)
    end
  end

  test "#similarity" do
    document1 = submitted_documents(:platypus)
    document2 = submitted_documents(:fraudulent_platypus)

    document1.windows = [[0, 1234], [1, 5678]]
    document2.windows = [[9, 1234], [1, 8765], [12, 4444]]

    match1, match2 = DocumentMatch.create_from!(document1, document2)

    assert_in_delta 0.3333, match1.similarity
    assert_in_delta 0.5, match2.similarity
  end
end
