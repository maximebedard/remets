class SubmissionCreation
  attr_reader :submission

  def initialize(submission_params)
    @submission_params = submission_params
  end

  def perform
    update_document_params
    create_submission
    fingerprint_documents
    complete_submission

    submission
  end

  private

  def update_document_params
    documents_params =
      @submission_params.fetch(:documents_attributes, []).map do |doc|
        { file: doc }
      end
    @submission_params.update(documents_attributes: documents_params)
  end

  def create_submission
    @submission = Submission.new(@submission_params)
  end

  def fingerprint_documents
    service = Winnowing.new
    @submission.documents.each do |document|
      document.windows = service.perform(document.content)
    end
  end

  def complete_submission
    submission.save!
  end
end
