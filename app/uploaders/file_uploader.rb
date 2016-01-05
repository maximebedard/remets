class FileUploader < CarrierWave::Uploader::Base
  before :cache, :update_original_filename

  version :sanitized, if: :can_be_sanitized? do
    process :sanitize_content
  end

  def filename
    [secure_token, file.extension.presence].compact.join(".") if original_filename.present?
  end

  def store_dir
    "#{super}/#{model.class.to_s.underscore}"
  end

  def cache_dir
    "#{super}/#{model.class.to_s.underscore}"
  end

  private

  def secure_token
    model.file_secure_token ||= SecureRandom.hex
  end

  def update_original_filename(file)
    model.file_original_name ||= file.original_filename.downcase if file.respond_to?(:original_filename)
  end

  def can_be_sanitized?(file)
    Sanitizer.can_be_sanitized?(file.extension)
  end

  def sanitize_content
    manipulate! do |file|
      sanitizer = Sanitizer.for_extension(File.extname(file.path)[1..-1])
      sanitizer = sanitizer.new(file.read)

      file.seek(0)
      file.write(sanitizer.sanitize)
    end
  end

  def manipulate!(&block)
    cache_stored_file! unless cached?
    File.open(current_path, "r+", &block)
  end
end
