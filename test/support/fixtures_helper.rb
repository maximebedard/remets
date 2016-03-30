module Remets
  module FixturesHelper
    %w(document boilerplate_document reference_document graded_document).each do |type|
      define_method("#{type}_upload_yaml") do |basename|
        uploader = upload(type.classify.constantize, basename)
        generate_yaml(uploader)
      end
    end

    def password(value = "password")
      BCrypt::Password.create(value, cost: 4)
    end

    private

    def generate_yaml(uploader)
      <<-YAML.strip_heredoc
        file_ptr: #{uploader.filename}
          file_original_name: #{uploader.model.file_original_name}
          file_secure_token: #{uploader.model.file_secure_token}
      YAML
    end

    def upload(model_klass, basename, mounted_as: nil)
      uploader = uploader_for(model_klass, mounted_as: mounted_as)
      store_file!(uploader, basename)
      uploader
    end

    def fixture_upload_path(model_klass, basename)
      Rails.root.join("test/fixtures/files/#{model_klass.to_s.underscore.pluralize}/#{basename}")
    end

    def uploader_for(model_klass, mounted_as: nil)
      mounted_as ||= model_klass.uploaders.keys.first
      model_klass.uploaders[mounted_as].new(model_klass.new, mounted_as)
    end

    def store_file!(uploader, basename)
      File.open(fixture_upload_path(uploader.model.class, basename)) do |f|
        uploader.store!(f)
      end
    end
  end
end

ActiveRecord::FixtureSet.context_class.include Remets::FixturesHelper
