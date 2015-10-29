class SubmissionCreation
  attr_reader :submission

  def initialize(submission_params)
    @submission_params = submission_params
  end

  def perform
    create_submission
    fingerprint_documents

    submission
  end

  private

  def create_submission
    @submission = Submission.create(@submission_params)
  end

  def fingerprint_documents
    return unless @submission.valid?

    @submission.documents.each do |document|
      DocumentFingerprintingWorker.perform_async(document.id)
    end
  end
end
