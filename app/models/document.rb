class Document < ActiveRecord::Base
  mount_uploader :file_ptr, FileUploader

  belongs_to :submission
  has_one :user, through: :submission

  validates :file_ptr, presence: true

  scope :all_fingerprinted_except, lambda { |document|
    where.not(id: document.id)
      .where('array_length(fingerprints, 1) > 0')
  }

  delegate :file, to: :file_ptr

  def content
    @content ||= File.open(file_ptr.current_path, 'r').read
  end

  def sanitized?
    file_ptr.version_exists?(:sanitized)
  end

  def fingerprinted?
    fingerprinted_at.present?
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
