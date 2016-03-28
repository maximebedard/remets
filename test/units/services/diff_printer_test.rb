require "test_helper"

class DiffPrinterTest < ActiveSupport::TestCase
  setup do
    @document1 = documents(:litterature)
    @document2 = documents(:litterature_with_one_match)

    DocumentFingerprintingJob.perform_now(@document1) #
    DocumentFingerprintingJob.perform_now(@document2) # # TODO: yolo
    DocumentIndexingJob.perform_now(@document1)       #
    DocumentIndexingJob.perform_now(@document2)       #

    @document_match = @document1.compare_with(@document2).first

    @service = DiffPrinter.new(@document_match)
  end

  test "#call" do
    # TODO: yolo
    @service.call
  end

  test "#build_context_diff" do
    # TODO: yolo
  end

  test "#build_context" do
    # TODO: yolo
  end

  test "#highlight" do
    assert_match(
      %r{<mark>Ete par arrivera souvenir<\/mark>},
      @service.highlight(@document1.sanitized_content, [285, 25]),
    )
  end

  test "#section_from backward clip" do
    assert_equal [0, 10], @service.section_from(
      @document1.sanitized_content,
      [3, 10],
    )
  end

  test "#section_from forward clip" do
    assert_equal [11, 10], @service.section_from(
      @document1.sanitized_content,
      [11, 19],
    )
  end

  test "#section_from foward and backward clip" do
    assert_equal [285, 25], @service.section_from(
      @document1.sanitized_content,
      [286, 304],
    )
  end

  test "#section_from clip to end" do
    assert_equal [392, 15], @service.section_from(
      @document1.sanitized_content,
      [395, 405],
    )
  end

  test "#section_from clip to beginning" do
    assert_equal [0, 21], @service.section_from(
      @document1.sanitized_content,
      [2, 13],
    )
  end

  test "#ranges_from" do
    assert_equal [[286, 304]], @service.ranges_from(
      @document1.windows,
      @document_match.match.fingerprints,
    )
  end
end
