require "test_helper"

class SimilarityBuilderTest < ActiveSupport::TestCase
  setup do
    @document1 = submitted_documents(:litterature)
    @document2 = submitted_documents(:litterature_with_one_match)

    @document_match = @document1.compare_with(@document2).first

    @service = SimilarityBuilder.new(@document_match)
  end

  test "#call with one match" do
    @document_match.stubs(fingerprints: [12345, 56789])
    @document1.stubs(windows: [[0, 54321], [4, 12345], [8, 56789], [12, 98765]])
    @document2.stubs(windows: [[0, 12345], [4, 56789], [8, 22222], [12, 33333]])

    similarity = @service.call

    assert_equal 4..8, similarity.range_a
    assert_equal 0..4, similarity.range_b
  end

  test "#call with multiple matches" do
    @document_match.stubs(fingerprints: [12345, 56789])
    @document1.stubs(windows: [[0, 54321], [4, 12345], [8, 56789], [12, 98765]])
    @document2.stubs(windows: [[0, 12345], [4, 56789], [8, 22222], [12, 33333], [16, 12345]])

    similarities = @service.call

    assert_equal 4..8, similarities[0].range_a
    assert_equal 0..4, similarities[0].range_b

    assert_equal 4..8, similarities[1].range_a
    assert_equal 16..20, similarities[1].range_b
  end
end
