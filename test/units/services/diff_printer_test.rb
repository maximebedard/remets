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
  end

  test "#build_context_diff" do
    # TODO: yolo
  end

  test "#build_context" do
    # TODO: yolo
  end

  test "#merge_overlapping_ranges" do
    # TODO: yolo
  end

  test "#merge_range" do
    # TODO: yolo
  end

  test "#grow_ranges" do
    # TODO: yolo
  end

  test "#grow_range" do
    # TODO: yolo
  end

  test "#rgrow" do
    # TODO: yolo
  end

  test "#lgrow" do
    # TODO: yolo
  end

  test "#offsets_for" do
    # TODO: yolo
  end

  test "#highlight" do
    assert_match(
      %r{<mark>Ete par arrivera souvenir<\/mark>},
      @service.highlight(@document1.sanitized_content, 285..309),
    )
  end

  test "#ranges_from" do
    assert_equal [286..299], @service.ranges_from(
      @document1.windows,
      @document_match.match.fingerprints,
    )
  end
end

class DiffDupPrinterTest < ActiveSupport::TestCase
  setup do
    @document1 = documents(:platypus)
    @document2 = documents(:fraudulent_platypus)

    DocumentFingerprintingJob.perform_now(@document1) #
    DocumentFingerprintingJob.perform_now(@document2) # # TODO: yolo
    DocumentIndexingJob.perform_now(@document1)       #
    DocumentIndexingJob.perform_now(@document2)       #

    @document_match = @document1.compare_with(@document2).first

    @service = DiffPrinter.new(@document_match)
  end

  test "#call" do
    # TODO: yolo
  end

  test "#build_context_diff" do
    # TODO: yolo
  end

  test "#build_context" do
    # TODO: yolo
  end

  test "#merge_overlapping_ranges" do
    # TODO: yolo
  end

  test "#merge_range" do
    # TODO: yolo
  end

  test "#grow_ranges" do
    # TODO: yolo
  end

  test "#grow_range" do
    # TODO: yolo
  end

  test "#rgrow" do
    # TODO: yolo
  end

  test "#lgrow" do
    # TODO: yolo
  end

  test "#offsets_for" do
    # TODO: yolo
  end

  test "#highlight" do
    # assert_match(
    #   %r{<mark>platypus (Ornithorhynchus anatinus) also known as the duck-billed platypus<\/mark>},
    #   @service.highlight(@document1.sanitized_content, 4..77),
    # )
  end

  test "#ranges_from" do
    assert_equal [
      4..9, 14..28, 55..75, 80..94, 100..108, 135..149, 175..182, 187..191,
      196..202, 208..214, 236..245, 250..254, 283..286, 291..296, 301..311, 317..327,
      338..357, 363..369, 375..390, 405..418, 430..437, 450..465, 470..475, 481..486,
      510..518, 532..592, 597..625, 678..690, 697..704, 710..721, 726..729, 734..753,
      786..807, 818..827, 832..839, 857..949, 954..960, 980..1012, 1029..1045, 1079..1092,
      1097..1110, 1115..1122, 1157..1160, 1175..1181, 1186..1222, 1232..1236, 1241..1255,
      1260..1267, 1290..1326, 1331..1337, 1342..1347, 1376..1380, 1385..1393, 1399..1403
    ], @service.ranges_from(
      @document1.windows,
      @document_match.match.fingerprints,
    )
  end
end
