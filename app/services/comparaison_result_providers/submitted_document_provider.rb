module ComparaisonResultProviders
  class SubmittedDocumentProvider
    def call(reference, compared)
      fingerprints = reference.fingerprints & compared.fingerprints
      fingerprints -= boilerplate_fingerprints
      fingerprints -= same_submission_fingerprints
      return if fingerprints.empty?

      ComparaisonResult.new(
        reference: reference,
        compared: compared,
        fingerprints: fingerprints,
      )
    end

    private

    def boilerplate_fingerprints(reference)
      reference
        .submission
        .evaluation
        .boilerplate_documents
        .pluck(:fingerprints)
        .flatten
    end

    def same_submission_fingerprints(reference)
      reference
        .submission
        .submitted_documents
        .all_fingerprinted_except(reference)
        .pluck(:fingerprints)
        .flatten
    end
  end
end
