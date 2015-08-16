class Submission < ActiveRecord::Base
  mount_uploader :document, DocumentUploader

  validates :document, presence: true
  validates :document_signature, presence: true

  def document_content
    @document_content ||= File.open(self.document.current_path, 'r').read
  end
end
