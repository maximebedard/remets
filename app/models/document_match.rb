class DocumentMatch < ActiveRecord::Base
  belongs_to :reference_document, class_name: Document
  belongs_to :compared_document, class_name: Document
  belongs_to :match

  validates(
    :reference_document_id,
    :compared_document_id,
    :match_id,
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
    return unless match = Matcher.new(reference, compared).call

    [
      create!(
        reference_document: reference,
        compared_document: compared,
        match: match,
        similarity: match.fingerprints.size.to_f / compared.fingerprints.size,
      ),
      create!(
        reference_document: compared,
        compared_document: reference,
        match: match,
        similarity: match.fingerprints.size.to_f / reference.fingerprints.size,
      ),
    ]
  end
end
