module FileWithSecureToken
  extend ActiveSupport::Concern

  included do
    before :cache, :update_original_filename
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
end
