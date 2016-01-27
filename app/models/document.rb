class Document < ActiveRecord::Base
  include Fingerprintable

  belongs_to :submission

  has_many :document_matches, foreign_key: :reference_document_id

  after_save :add_to_index

  private

  def add_to_index
    return unless fingerprints_changed? || indexes_changed?
    DocumentIndexingJob.perform_later(id)
  end
end
