module UniqueJob
  extend ActiveSupport::Concern

  included do
    around_perform do |job, block|
      job.acquire_lock(&block)
    end

    cattr_accessor :timeout
    cattr_accessor :expiration

    self.timeout = 0
    self.expiration = 10
  end

  def acquire_lock(&block)
    mutex = Redis::Lock.new(
      lock_key(*arguments),
      Remets.redis,
      expiration: self.class.expiration,
      timeout: self.class.timeout,
    )
    mutex.lock(&block)
  end

  def lock_key(*args)
    ActiveJob::Arguments.serialize([self.class.name] + args).join("-")
  end

  def active?(*args)
    Remets.redis.exists(lock_key(args))
  end
end
