class DocumentMatch < ActiveRecord::Base
  belongs_to :reference_document, class_name: Document
  belongs_to :compared_document, class_name: Document

  validates :reference_document_id,
    :compared_document_id,
    :matching_fingerprints,
    presence: true
end
