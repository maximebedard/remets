class ComparaisonResult
  attr_reader(
    :reference,
    :compared,
    :fingerprints,
  )

  def initialize(reference:, compared:, fingerprints:)
    @reference = reference
    @compared = compared
    @fingerprints = fingerprints
    @accuracy = calculate_accuracy
  end

  def to_h
    {
      "reference".freeze => reference,
      "compared".freeze => compared,
      "fingerprints".freeze => fingerprints,
      "accuracy".freeze => accuracy,
    }
  end

  def accuracy
    @accuracy ||= calculate_accuracy
  end

  private

  def calculate_accuracy
    fingerprints.size.to_f / compared.fingerprints.size
  end
end
