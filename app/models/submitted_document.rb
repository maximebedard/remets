class SubmittedDocument < ActiveRecord::Base
  include HasFile
  include HasSanitizedFile

  belongs_to :submission

  has_many :document_matches, foreign_key: :reference_document_id

  def compare_with(other)
    document_matches.where(compared_document_id: other.id)
  end

  def enqueue_indexing_job
    return unless fingerprints_changed? || indexes_changed?
    DocumentIndexingJob.perform_later(self)
  end
end
