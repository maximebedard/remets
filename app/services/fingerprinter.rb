class Fingerprinter
  attr_accessor :submission_or_handover

  def initialize(submission_or_handover, params)
    @submission_or_handover = submission_or_handover
    @params = params
  end

  def call
    deep_extract_archive
    assign_and_persist
    fingerprint_documents

    submission_or_handover
  end

  private

  def deep_extract_archive
    # this is where we will extract archive recursively.
  end

  def assign_and_persist
    @submission_or_handover.attributes = @params
    @submission_or_handover.save
  end

  def fingerprint_documents
    return unless @submission_or_handover.valid?

    @submission_or_handover.documents.each do |document|
      DocumentFingerprintingJob.perform_later(document.id)
    end
  end
end
