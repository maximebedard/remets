class DocumentMatch < ActiveRecord::Base
  belongs_to :reference_document, class_name: Document
  belongs_to :compared_document, class_name: Document

  validates :reference_document_id,
    :compared_document_id,
    :fingerprints,
    presence: true

  scope :relevant_matches, lambda { |document|
    where(reference_document_id: document.id)
      .order("array_length(fingerprints, 1) DESC")
  }

  def self.create_from!(reference, compared)
    matching_fingerprints = reference.fingerprints & compared.fingerprints
    return unless matching_fingerprints.present?

    create!(
      reference_document: reference,
      compared_document: compared,
      fingerprints: matching_fingerprints,
    )
  end
end
