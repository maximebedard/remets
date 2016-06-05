class RemoteFile
  attr_reader :key

  def initialize(key)
    @key = key
  end

  def url
    s3_object.public_url
  end

  def extension
    File.extname(key)[1..-1]
  end

  delegate :exists?, to: :s3_object

  def content(*args)
    s3_object.get.body.read(*args)
  rescue Aws::S3::Errors::NotFound
    nil # should probably raise something else here.
  end

  private

  def s3_object
    @s3_object ||= Bucket.object(key)
  end
end
