class FileUploader < CarrierWave::Uploader::Base
  version :sanitized, if: :can_be_sanitized? do
    process :sanitize_content
  end

  def filename
    "#{SecureRandom.hex}.#{file.extension}"
  end

  def store_dir
    byebug
    "#{super}/#{model.class.to_s.underscore}"
  end

  def cache_dir
    "#{super}/#{model.class.to_s.underscore}"
  end

  private

  def can_be_sanitized?(file)
    Sanitizer.can_be_sanitized?(file.extension)
  end

  def sanitize_content
    manipulate! do |file|
      sanitizer = Sanitizer.for_extension(File.extname(file.path)[1..-1])
      sanitizer = sanitizer.new(file.read)
      file.write(sanitizer.sanitize)
    end
  end

  def manipulate!(&block)
    cache_stored_file! unless cached?
    File.open(current_path, 'r+', &block)
  end
end
