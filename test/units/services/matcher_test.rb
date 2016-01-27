require "test_helper"

class MatcherTest < ActiveSupport::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  test "#call returns the matching fingerprints" do
    reference = submissions(:log121_lab1).documents.create!(
      file_ptr: empty_file_upload,
      windows: [[0, 1234], [1, 9876], [4, 5678]],
    )
    compared = submissions(:log121_lab1).documents.create!(
      file_ptr: empty_file_upload,
      windows: [[0, 1234], [1, 3456], [4, 6666]],
    )

    assert match = Matcher.new(reference, compared).call
    assert_equal [1234], match.fingerprints
  end

  test "#call returns the matching fingerprints but excludes the boilerplate documents fingerprints" do
    reference = submissions(:log121_lab1).documents.create!(
      file_ptr: empty_file_upload,
      windows: [[0, 1234], [1, 9876], [4, 5678]],
    )
    compared = submissions(:log121_lab1).documents.create!(
      file_ptr: empty_file_upload,
      windows: [[0, 1234], [1, 3456], [4, 6666]],
    )
    boilerplate_documents(:makefile_boilerplate).update!(
      file_ptr: empty_file_upload,
      windows: [[0, 1234]],
    )

    assert_nil Matcher.new(reference, compared).call
  end
end
