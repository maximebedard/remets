require "test_helper"

class FileUploaderTest < ActiveSupport::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  class FileUploaderModel
    attr_accessor :file_secure_token, :file_original_name
  end

  setup do
    @model = FileUploaderModel.new
    @uploader = FileUploader.new(@model, :file_ptr)
  end

  test "#filename uses a random hex" do
    SecureRandom.stubs(hex: "HENRY")
    @uploader.store!(sanitizable_file_upload)

    assert_equal "HENRY.txt", @uploader.filename
  end

  test "#filename uses the model filename when present" do
    @model.stubs(file_secure_token: "HENRY")
    @uploader.store!(sanitizable_file_upload)

    assert_equal "HENRY.txt", @uploader.filename
  end

  test "#filename returns the basepath without the extension when the file has no extension" do
    SecureRandom.stubs(hex: "HENRY")
    @uploader.store!(without_extension_file_upload)

    assert_equal "HENRY", @uploader.filename
  end

  test "#store_dir returns the upload dir scoped to the model" do
    assert_equal "uploads/file_uploader_test/file_uploader_model",
      @uploader.store_dir
  end

  test "#cache_dir returns the upload temp dir scoped to the model" do
    assert_equal "uploads/tmp/file_uploader_test/file_uploader_model",
      @uploader.cache_dir
  end
end
