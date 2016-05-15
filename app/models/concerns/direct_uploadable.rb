module DirectUploadable
  extend ActiveSupport::Concern

  module ClassMethods
    def store_key
      "uploads/#{to_s.underscore}/#{SecureRandom.uuid}/${filename}"
    end

    def presigned_post(success_action_status: "201", acl: "public-read", **options)
      @presigned_post ||= Bucket.presigned_post(
        key: store_key,
        success_action_status: success_action_status,
        acl: acl,
        **options,
      )
    end
  end

  def file
    RemoteFile.new(file_ptr)
  end
end
