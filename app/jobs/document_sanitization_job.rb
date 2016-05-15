class DocumentSanitizationJob < ActiveJob::Base
  queue_as :default

  def perform(document)
    # stream read file from s3
    # sanitize content
    # stream write content to s3
  end
end
