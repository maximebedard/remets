class DocumentMatch < ActiveRecord::Base
  belongs_to :reference_document, class_name: Document
  belongs_to :compared_document, class_name: Document

  validates :reference_document_id,
    :compared_document_id,
    :fingerprints,
    presence: true

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
