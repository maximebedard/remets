class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :submission

  validates :file, presence: true
  validates :signature, presence: true

  def content
    @content ||= File.open(self.file.current_path, 'r').read
  end
end
