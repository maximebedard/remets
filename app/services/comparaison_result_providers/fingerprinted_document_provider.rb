module ComparaisonResultProviders
  class FingerprintedDocumentProvider
    def call(reference, compared)
      fingerprints = reference.fingerprints & compared.fingerprints
      return if fingerprints.empty?

      ComparaisonResult.new(
        reference: reference,
        compared: compared,
        fingerprints: fingerprints,
      )
    end
  end
end
