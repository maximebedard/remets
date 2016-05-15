class SubmittedDocument < ActiveRecord::Base
  include DirectUploadable
  belongs_to :submission

  has_many :document_matches, foreign_key: :reference_document_id

  scope :all_fingerprinted_except, lambda { |document|
    where.not(id: document.id)
      .where("array_length(fingerprints, 1) > 0")
  }

  def compare_with(other)
    document_matches.where(compared_document_id: other.id)
  end

  def sanitized_file
    RemoteFile.new(sanitized_file_ptr)
  end

  def sanitized_file_ptr
    "sanitized/#{file_ptr}"
  end

  def fingerprinted?
    fingerprinted_at.present?
  end

  def windows
    indexes.zip(fingerprints)
  end

  def windows=(value)
    self.indexes, self.fingerprints = value.transpose
  end

  def create_sanitized_file
    # return unless file_ptr_changed?
    DocumentSanitizationJob.perform_later(self)
  end

  def add_to_index
    # return unless fingerprints_changed? || indexes_changed?
    DocumentIndexingJob.perform_later(self)
  end
end
