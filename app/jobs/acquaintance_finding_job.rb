class AcquaintanceFindingJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    acquaintances = AcquaintancesFinder.new(user).call
    Acquaintance.save_to_cache(user, acquaintances)
  end
end
