class Document < ActiveRecord::Base
  mount_uploader :file_ptr, FileUploader

  delegate :file, to: :file_ptr

  belongs_to :submission
  has_one :user, through: :submission

  validates :file, presence: true

  scope :all_except, -> (document) { where.not(id: document.id) }

  def content
    @content ||= File.open(file_ptr.current_path, 'r').read
  end

  def sanitized?
    !file_ptr.sanitized.nil?
  end

  def sanitized_content
    @sanitized_content ||= File.open(file_ptr.sanitized.current_path, 'r').read if sanitized?
  end

  def windows
    @windows ||= indexes.zip(fingerprints)
  end

  def windows=(value)
    self.indexes, self.fingerprints = value.transpose
  end
end
