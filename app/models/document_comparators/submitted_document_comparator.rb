module DocumentComparators
  class SubmittedDocumentComparator
    def intersect(a, b)
      fingerprints = a.fingerprints & b.fingerprints
      fingerprints -= boilerplate_fingerprints
      fingerprints -= same_submission_fingerprints
      fingerprints
    end

    def all(a, b)
      a.fingerprints & b.fingerprints
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
