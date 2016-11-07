module Remets
  extend self

  def aws_configure!
    Aws.config.update(
      region: ENV["S3_REGION"],
      credentials: Aws::Credentials.new(
        ENV["AWS_ACCESS_KEY_ID"],
        ENV["AWS_SECRET_ACCESS_KEY"],
      ),
    )
  end

  def aws_bucket
    @aws_bucket ||= Aws::S3::Bucket.new(
      name: ENV["S3_BUCKET"],
      client: aws_client,
    )
  end

  private

  def aws_client
    @aws_client ||= Aws::S3::Client.new
  end
end

Remets.aws_configure!
