class SubmittedDocument < ActiveRecord::Base
  include HasFile
  include HasSanitizedFile

  belongs_to :submission

  has_many :document_matches, foreign_key: :reference_document_id

  after_save :enqueue_indexing_job

  def compare_with(other)
    document_matches.where(compared_document_id: other.id)
  end

  def enqueue_indexing_job
    # remove this callback bullshit
    # return unless fingerprints_changed? || indexes_changed?
    # DocumentIndexingJob.perform_later(self)
  end
end
