CarrierWave.configure do |config|
  config.permissions = 0600
  config.directory_permissions = 0700
  config.storage = :file

  config.root = Rails.root
  config.store_dir = "uploads"
  config.cache_dir = "uploads/tmp"
  config.enable_processing = true

  case
  when Rails.env.test?
    config.root = "test/fixtures"
    config.storage = :file
  when Rails.env.production?
    config.fog_provider = "fog/aws"
    config.storage = :fog
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    }
    config.fog_directory = ENV["S3_BUCKET_NAME"]
  end
end
