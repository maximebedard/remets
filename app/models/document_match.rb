class DocumentMatch < ActiveRecord::Base
  belongs_to :reference_document, class_name: Document
  belongs_to :compared_document, class_name: Document

  validates(
    :reference_document_id,
    :compared_document_id,
    :fingerprints,
    :similarity,
    presence: true,
  )

  validates(
    :similarity,
    numericality: { greater_than: 0.0 },
  )

  scope :relevant_matches, lambda { |document|
    where(reference_document_id: document.id)
      .order(:similarity)
  }

  def self.create_from!(reference, compared)
    fingerprints = reference.fingerprints & compared.fingerprints
    return unless fingerprints.present?

    [
      create!(
        reference_document: reference,
        compared_document: compared,
        fingerprints: fingerprints, # this makes me sad :(
        similarity: fingerprints.size.to_f / compared.fingerprints.size,
      ),
      create!(
        reference_document: compared,
        compared_document: reference,
        fingerprints: fingerprints, # this makes me sad :(
        similarity: fingerprints.size.to_f / reference.fingerprints.size,
      ),
    ]
  end
end
