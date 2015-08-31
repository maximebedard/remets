class FileUploader < CarrierWave::Uploader::Base
  storage :file

  TEXT_FILE_EXTS = %w(txt pdf doc docx md tex)
  SOURCE_FILE_EXTS = []

  def extension_white_list
    TEXT_FILE_EXTS + SOURCE_FILE_EXTS
  end
end
