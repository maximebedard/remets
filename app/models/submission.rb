class Submission < ActiveRecord::Base
  mount_uploader :document, DocumentUploader

  validate :document, presence: true
  validate :document_signature, presence: true

  has_many :shingles
end
