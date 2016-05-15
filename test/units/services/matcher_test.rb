require "test_helper"

class MatcherTest < ActiveSupport::TestCase
  test "#call returns the matching fingerprints" do
    reference = submissions(:log121_lab1_1).submitted_documents.create!(
      file_ptr: submitted_documents(:empty).file_ptr,
      windows: [[0, 1234], [1, 9876], [4, 5678]],
    )
    compared = submissions(:log121_lab1_2).submitted_documents.create!(
      file_ptr: submitted_documents(:empty).file_ptr,
      windows: [[0, 1234], [1, 3456], [4, 6666]],
    )

    assert match = Matcher.new(reference, compared).call
    assert_equal [1234], match.fingerprints
  end

  test "#call returns nil when the documents belongs to the same submission" do
    reference = submissions(:log121_lab1_1).submitted_documents.create!(
      file_ptr: submitted_documents(:empty).file_ptr,
      windows: [[0, 1234], [1, 9876], [4, 5678]],
    )
    compared = submissions(:log121_lab1_1).submitted_documents.create!(
      file_ptr: submitted_documents(:empty).file_ptr,
      windows: [[0, 1234], [1, 3456], [4, 6666]],
    )

    assert_nil Matcher.new(reference, compared).call
  end

  test "#call returns the matching fingerprints but excludes the boilerplate documents fingerprints" do
    reference = submissions(:log121_lab1_1).submitted_documents.create!(
      file_ptr: submitted_documents(:empty).file_ptr,
      windows: [[0, 1234], [1, 4567], [4, 5678]],
    )
    compared = submissions(:log121_lab1_2).submitted_documents.create!(
      file_ptr: submitted_documents(:empty).file_ptr,
      windows: [[0, 1234], [1, 4567], [4, 6666]],
    )
    boilerplate_documents(:platypus_boilerplate).update!(
      file_ptr: submitted_documents(:empty).file_ptr,
      windows: [[0, 1234]],
    )

    assert match = Matcher.new(reference, compared).call
    assert_equal [4567], match.fingerprints
  end
end
