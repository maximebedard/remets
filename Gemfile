source "https://rubygems.org"
ruby "2.3.1"

gem "aws-sdk"
gem "bcrypt"
gem "bootstrap-sass"
gem "font-awesome-sass"
gem "jbuilder"
gem "jquery-rails"
gem "omniauth-google-oauth2"
gem "omniauth"
gem "pg"
gem "puma"
gem "rails", "~> 5.0.0"
gem "responders"
gem "sass-rails", github: "rails/sass-rails"
gem "sidekiq"
gem "sinatra", require: false
gem "sprockets"
gem "turbolinks"
gem "uglifier"

if ENV["LOCAL_FAST_WINNOWER"]
  gem "fast_winnower", path: "../fast_winnower"
else
  gem "fast_winnower", github: "maximebedard/fast_winnower"
end

group :development, :test do
  gem "rubocop", require: false
  gem "ruby-prof", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "pry-byebug"
  gem "railroady"
end

group :test do
  gem "codeclimate-test-reporter", require: false
  gem "mocha", require: false
  gem "webmock"
end

group :production do
  gem "rails_12factor"
end
