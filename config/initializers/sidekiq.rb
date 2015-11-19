if Rails.env.development? || Rails.env.testing?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
