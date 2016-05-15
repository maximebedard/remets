Aws.config.update(
  region: ENV["S3_REGION"],
  credentials: Aws::Credentials.new(
    ENV["AWS_ACCESS_KEY_ID"],
    ENV["AWS_SECRET_ACCESS_KEY"],
  ),
)

AwsClient = Aws::S3::Client.new

Bucket = Aws::S3::Bucket.new(
  name: ENV["S3_BUCKET"],
  client: AwsClient,
)
