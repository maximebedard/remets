class Matcher
  def initialize(reference, compared)
    @reference = reference
    @compared = compared
  end

  def call
    fingerprints = (reference.fingerprints & compared.fingerprints) - boilerplate_fingerprints
    return unless fingerprints.present?

    Match.create!(fingerprints: fingerprints)
  end

  private

  attr_reader :reference, :compared

  def boilerplate_fingerprints
    reference.submission.handover.boilerplate_documents.pluck(:fingerprints).flatten
  end
end
