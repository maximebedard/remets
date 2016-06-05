module HasSanitizedFile
  extend ActiveSupport::Concern

  included do
    scope :all_fingerprinted_except, lambda { |document|
      where.not(id: document.id)
        .where("array_length(fingerprints, 1) > 0")
    }

    after_save :enqueue_sanitization_job
    after_save :enqueue_fingerprinting_job
  end

  def fingerprinted?
    fingerprinted_at.present?
  end

  def windows
    indexes.zip(fingerprints)
  end

  def windows=(value)
    self.indexes, self.fingerprints = value.transpose
  end

  def sanitized_file
    RemoteFile.new(sanitized_file_ptr)
  end

  def sanitizable?
    Sanitizer.can_be_sanitized?(file)
  end

  def fingerprintable?
    sanitized_file.exists?
  end

  def sanitized?
    sanitized_file.exists?
  end

  def generate_sanitized_content
    Sanitizer.build_for(file).safe_sanitize
  end

  def generate_windows
    Winnower.windows_from_content(
      sanitized_file.content,
    ).to_a
  end

  def sanitized_file_ptr
    "sanitized/#{file_ptr}"
  end

  def enqueue_sanitization_job
    # remove this callback bullshit
    # return unless file_ptr_changed?
    # DocumentSanitizationJob.perform_later(self)
  end

  def enqueue_fingerprinting_job
    # remove this callback bullshit
    # something something
    # DocumentFingerprintingJob.perform_later(self)
  end
end
