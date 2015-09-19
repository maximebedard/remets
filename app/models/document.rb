class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :submission

  validates :file, presence: true

  def content
    @content ||= File.open(self.file.current_path, 'r').read
  end

  def extension
    @extension ||= self.file.file.extension.downcase
  end

  def windows
    self.indexes.zip(self.fingerprints)
  end

  def windows=(value)
    self.indexes, self.fingerprints = value.transpose
  end
end
