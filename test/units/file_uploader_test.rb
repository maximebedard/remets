require 'test_helper'

class FileUploaderTest < ActiveSupport::TestCase
  class FileUploaderModel
    def read_attribute(*)
      nil
    end
  end

  setup do
    @model = FileUploaderModel.new
    @uploader = FileUploader.new(@model, :file_ptr)
  end

  test '#filename uses a random hex' do
    SecureRandom.stubs(hex: 'HENRY')
    @uploader.store!(sanitizable_file)

    assert_equal 'HENRY.txt', @uploader.filename
  end

  test '#filename uses the model filename when present' do
    @model.stubs(:read_attribute).with(:file_ptr).returns('HENRY.txt')
    @uploader.store!(sanitizable_file)

    assert_equal 'HENRY.txt', @uploader.filename
  end

  test '#filename returns the basepath without the extension when the file has no extension' do
    SecureRandom.stubs(hex: 'HENRY')
    @uploader.store!(file_without_extension)

    assert_equal 'HENRY', @uploader.filename
  end

  test '#store_dir returns the upload dir scoped to the model' do
    assert_equal 'uploads/file_uploader_test/file_uploader_model',
      @uploader.store_dir
  end

  test '#cache_dir returns the upload temp dir scoped to the model' do
    assert_equal 'uploads/tmp/file_uploader_test/file_uploader_model',
      @uploader.cache_dir
  end

  test '#sanitized creates a sanitized version when the format is supported' do
    SecureRandom.stubs(hex: 'HENRY')
    @uploader.store!(sanitizable_file)

    assert @uploader.version_exists?(:sanitized)
  end

  test '#sanitized does not create a sanitized version when there is no extension' do
    SecureRandom.stubs(hex: 'HENRY')
    @uploader.store!(file_without_extension)

    refute @uploader.version_exists?(:sanitized)
  end

  test '#sanitized does not create a sanitized version when the format is unsupported' do
    SecureRandom.stubs(hex: 'HENRY')
    @uploader.store!(unsanitizable_file)

    refute @uploader.version_exists?(:sanitized)
  end

  private

  def sanitizable_file
    @sanitizable_file ||= File.open("#{file_fixtures_path}/605975483/platypus1.txt")
  end

  def unsanitizable_file
    @unsanitizable_file ||= File.open("#{file_fixtures_path}/605975485/platypus.jpg")
  end

  def file_without_extension
    @file_without_extension ||= File.open("#{file_fixtures_path}/605975486/platypus")
  end

  def file_fixtures_path
    'test/fixtures/files/documents/file'
  end
end
