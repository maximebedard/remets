class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :submission

  validates :file, presence: true

  scope :all_except, -> (document) { where.not(id: document.id) }

  def content
    @content ||= File.open(self.file.current_path, 'r').read
  end

  def scrubbed_content
    @sanitized_content ||= Scrubber.for_document(self).scrubbed_content
  end

  def extension
    @extension ||= self.file.file.extension.downcase
  end

  def windows
    @windows ||= self.indexes.zip(self.fingerprints)
  end

  def windows=(value)
    self.indexes, self.fingerprints = value.transpose
  end
end
