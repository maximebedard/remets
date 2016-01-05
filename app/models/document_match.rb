class DocumentMatch < ActiveRecord::Base
  belongs_to :reference_document, class_name: Document
  belongs_to :compared_document, class_name: Document
  belongs_to :match, inverse_of: :document_matches

  delegate :fingerprints, to: :match

  validates(
    :reference_document_id,
    :compared_document_id,
    :match,
    presence: true,
  )

  scope :relevant_matches, lambda { |document|
    joins(:match)
      .where(reference_document_id: document.id)
      .order("array_length(fingerprints, 1) DESC")
  }

  def self.create_from!(reference, compared)
    fingerprints = reference.fingerprints & compared.fingerprints
    return unless fingerprints.present?

    match = Match.create!(fingerprints: fingerprints)

    document_match1 = create!(
      reference_document: reference,
      compared_document: compared,
      match: match,
    )
    document_match2 = create!(
      reference_document: compared,
      compared_document: reference,
      match: match,
    )

    [document_match1, document_match2]
  end

  def similarity
    fingerprints.size.to_f / compared_document.fingerprints.size
  end
end
