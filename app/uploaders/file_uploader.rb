class FileUploader < CarrierWave::Uploader::Base
  include FileWithSecureToken
end
