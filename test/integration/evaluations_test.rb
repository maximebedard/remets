require "test_helper"

class EvaluationsTest < ActionDispatch::IntegrationTest
  include Remets::SanitizedDocumentFileUploadHelper

  setup do
    sign_in(users(:gaston))
  end

  test "create a evaluation" do
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
      due_date: 5.days.from_now,
      reference_documents_attributes: [{ file_ptr: @file1 }],
      boilerplate_documents_attributes: [{ file_ptr: @file2 }],
    )

    assert_equal "Pants", @evaluation.title
    assert_equal description, @evaluation.description

    _reference_document = @evaluation.reference_documents.first
    assert_equal 1, @evaluation.reference_documents.size

    boilerplate_document = @evaluation.boilerplate_documents.first
    assert_equal 1, @evaluation.boilerplate_documents.size

    assert_not_empty boilerplate_document.indexes
    assert_not_empty boilerplate_document.fingerprints
    assert_not_empty boilerplate_document.windows
  end

  private

  def submit(evaluation_params = {})
    perform_enqueued_jobs do
      post "/evaluations", evaluation: evaluation_params
      @evaluation = Evaluation.last
    end
  end
end
