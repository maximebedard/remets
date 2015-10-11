class FileUploader < CarrierWave::Uploader::Base
  storage :file

  version :scrubbed_file, if: :can_be_scrubbed? do
    process :scrub_content
  end

  private

  def can_be_scrubbed?(file)
    Scrubber.can_be_scrubbed?(file.extension)
  end

  def scrub_content
    # TODO
  end
end
