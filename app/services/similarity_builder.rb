class SimilarityBuilder
  attr_reader :document_match

  def initialize(reference, compared, provider: ComparaisonResultProviders::FingerprintedDocumentProvider.new)
    @reference = reference
    @compared = compared
    @provider = provider
  end

  # If a1 in document 1 matches a2 in document 2, and b1
  # in document 1 matches b2 in document 2, and furthermore a1 and
  # b1 are consecutive in document 1 and a2 and b2 are consecutive in
  # document 2, then we have discovered a longer match across documents
  # consisting of a followed by b. While this merging of matches
  # is easy to implement, k-grams are naturally coarse and some of the
  # match is usually lost at the beginning and the end of the match.
  def call
    comparaison_result = @provider.call(@reference, @compared)
  end

  def build_similarities
    similarities = []

    windows_a = fingerprinted_windows(reference.windows)
    windows_b = fingerprinted_windows(compared.windows)
  end

  def fingerprinted_windows(windows)
    windows
      .select { |_, f| fingerprints.include?(f) }
      .sort_by(&:first)
  end

  def compared
    @compared ||= document_match.compared_document
  end

  def reference
    @reference ||= document_match.reference_document
  end

  def fingerprints
    @fingerprints ||= document_match.match.fingerprints
  end
end
