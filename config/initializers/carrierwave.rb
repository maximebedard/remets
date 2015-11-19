CarrierWave.configure do |config|
  config.permissions = 0600
  config.directory_permissions = 0700
  config.storage = :file

  config.root = Rails.root
  config.store_dir = 'uploads'
  config.cache_dir = 'uploads/tmp'

  if Rails.env.test?
    config.root = 'test/fixtures/files'
    config.storage = :file
    config.enable_processing = true
  end
end
