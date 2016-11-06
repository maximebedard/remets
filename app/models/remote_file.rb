class RemoteFile
  NotFoundError = Class.new(StandardError)

  attr_reader :key

  def initialize(key)
    @key = key
  end

  def url
    remote_object.public_url
  end

  def extension
    File.extname(key)[1..-1]
  end

  delegate(
    :exists?,
    to: :remote_object,
  )

  def read_content(*args)
    read_content!(*args)
  rescue NotFoundError
    nil
  end

  def read_content!(*args)
    remote_object.get.body.read(*args)
  rescue Aws::S3::Errors::NotFound
    raise NotFoundError
  end

  private

  def remote_object
    @remote_object ||= Remets.aws_bucket.object(key)
  end
end
