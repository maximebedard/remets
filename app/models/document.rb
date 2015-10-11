class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :submission
  has_one :user, through: :submission

  validates :file, presence: true

  scope :all_except, -> (document) { where.not(id: document.id) }

  def content
    @content ||= File.open(file.current_path, 'r').read
  end

  def has_scrubbed_version?
    !file.scrubbed.nil?
  end

  def scrubbed_content
    @scrubbed_content ||=
      if has_scrubbed_version?
        File.open(file.scrubbed.current_path, 'r').read
      end
  end

  def extension
    @extension ||= file.file.extension.downcase
  end

  def windows
    @windows ||= indexes.zip(fingerprints)
  end

  def windows=(value)
    self.indexes, self.fingerprints = value.transpose
  end
end
