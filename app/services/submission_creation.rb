class SubmissionCreation
  attr_reader :submission

  def initialize(submission_params)
    @submission_params = submission_params
  end

  def call
    update_document_params
    create_submission
    enqueue_fingerprinting_job

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
    @submission = Submission.create(@submission_params)
  end

  def enqueue_fingerprinting_job
    @submission.documents.each do |document|
      DocumentFingerprintingWorker.perform_later(document.id)
    end
  end
end
