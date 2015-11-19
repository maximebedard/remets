CarrierWave.configure do |config|
  config.permissions = 0600
  config.directory_permissions = 0700
  config.storage = :file

  config.root = Rails.root
  config.store_dir = 'uploads'
  config.cache_dir = 'uploads/tmp'

  config.root = 'test/fixtures/files' if Rails.env.test?
end
