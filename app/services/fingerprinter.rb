class Fingerprinter
  attr_accessor :submission_or_evaluation

  def initialize(submission_or_evaluation, params = {})
    @submission_or_evaluation = submission_or_evaluation
    @params = params
  end

  def call
    deep_extract_archive
    update
    fingerprint_documents

    submission_or_evaluation
  end

  private

  def deep_extract_archive
    # this is where we will extract archive recursively.
  end

  def update
    @submission_or_evaluation.update(@params)
  end

  def fingerprint_documents
    return unless @submission_or_evaluation.valid?

    @submission_or_evaluation.fingerprintable_documents.each do |document|
      DocumentFingerprintingJob.perform_later(document)
    end
  end
end
