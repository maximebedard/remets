class Matcher
  def initialize(reference, compared)
    @reference = reference
    @compared = compared
  end

  def call
    fingerprints = reference.fingerprints & compared.fingerprints
    fingerprints -= boilerplate_fingerprints
    fingerprints -= same_submission_fingerprints
    return unless fingerprints.present?

    Match.create!(fingerprints: fingerprints)
  end

  private

  attr_reader :reference, :compared

  def boilerplate_fingerprints
    reference.submission.evaluation.boilerplate_documents
      .pluck(:fingerprints).flatten
  end

  def same_submission_fingerprints
    reference.submission.submitted_documents.all_fingerprinted_except(reference)
      .pluck(:fingerprints).flatten
  end
end
