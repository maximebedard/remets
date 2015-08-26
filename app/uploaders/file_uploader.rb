class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def extension_white_list
    %w(txt pdf doc docx md tex)
  end
end
