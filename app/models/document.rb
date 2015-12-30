class Document < ActiveRecord::Base
  mount_uploader :file_ptr, FileUploader

  belongs_to :documentable, polymorphic: true

  validates :file_ptr, presence: true

  scope :all_fingerprinted_except, lambda do |document|
    where.not(id: document.id)
      .where("array_length(fingerprints, 1) > 0")
  end

  delegate :file, to: :file_ptr
  delegate :user, to: :documentable

  def sanitized?
    file_ptr.version_exists?(:sanitized)
  end

  def fingerprinted?
    fingerprinted_at.present?
  end

  def content
    @content ||= File.open(file_ptr.current_path, "r").read
  end

  def sanitized_content
    @sanitized_content ||= File.open(file_ptr.sanitized.current_path, "r").read if sanitized?
  end

  def windows
    indexes.zip(fingerprints)
  end

  def windows=(value)
    self.indexes, self.fingerprints = value.transpose
  end
end
