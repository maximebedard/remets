require "test_helper"

class HandoversTest < ActionDispatch::IntegrationTest
  include Remets::SanitizedDocumentFileUploadHelper

  test "create a handover" do
    @file1 = unsanitizable_file_upload
    @file2 = sanitizable_file_upload

    description = <<-MD.strip_heredoc
      # This is a markdown

      - a
      - b
    MD

    submit(
      title: "Pants",
      description: description,
      reference_documents_attributes: [{ file_ptr: @file1 }],
      boilerplate_documents_attributes: [{ file_ptr: @file2 }],
    )

    assert_equal "Pants", @handover.title
    assert_equal description, @handover.description

    _reference_document = @handover.reference_documents.first
    assert_equal 1, @handover.reference_documents.size

    boilerplate_document = @handover.boilerplate_documents.first
    assert_equal 1, @handover.boilerplate_documents.size

    assert_not_empty boilerplate_document.indexes
    assert_not_empty boilerplate_document.fingerprints
    assert_not_empty boilerplate_document.windows
  end

  private

  def submit(handover_params = {})
    perform_enqueued_jobs do
      post "/handovers", handover: handover_params
      @handover = Handover.last
    end
  end
end
