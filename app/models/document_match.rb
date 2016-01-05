class DocumentMatch < ActiveRecord::Base
  belongs_to :reference_document, class_name: Document
  belongs_to :compared_document, class_name: Document
  belongs_to :match, inverse_of: :document_matches

  validates(
    :reference_document_id,
    :compared_document_id,
    :match,
    presence: true,
  )

  scope :relevant_matches, lambda { |document|
    joins(:match)
      .where(reference_document_id: document.id)
      .sort_by(&:similarity)
  }

  def self.create_from!(reference, compared)
    fingerprints = reference.fingerprints & compared.fingerprints
    return unless fingerprints.present?

    match = Match.create!(fingerprints: fingerprints)

    [
      create!(
        reference_document: reference,
        compared_document: compared,
        match: match,
      ),
      create!(
        reference_document: compared,
        compared_document: reference,
        match: match,
      ),
    ]
  end

  def similarity
    match.fingerprints.size.to_f / compared_document.fingerprints.size
  end
end
