module Remets
  module FixtureUploadHelper
    def upload(model_klass, mounted_as, base_name)
      uploader = model_klass.uploaders[mounted_as]
        .new(model_klass.new, mounted_as)

      File.open(fixture_upload_path(model_klass, base_name)) { |f| uploader.store!(f) }

      uploader.filename
    end

    private

    def fixture_upload_path(model_klass, base_name)
      Rails.root.join("test/fixtures/files/#{model_klass.to_s.underscore.pluralize}/#{base_name}")
    end
  end
end

ActiveRecord::FixtureSet.context_class.include Remets::FixtureUploadHelper
