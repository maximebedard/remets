class Submission < ActiveRecord::Base
  mount_uploader :document, DocumentUploader

  validates :document, presence: true
  validates :document_signature, presence: true

  def document_content
    @document_content ||= File.open(self.document.current_path, 'r').read
  end

  def compare(other_submission)
    SubmissionComparaison.new(self, other_submission)
  end

  def compare_all
    self.class.where.not(id: self.id).map do |s|
      compare(s)
    end.sort_by do |c|
      c.resemblance
    end
  end
end
