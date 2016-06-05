source "https://rubygems.org"
ruby "2.3.0"

gem "rails", "4.2.5.2"
gem "pg"
gem "puma"
gem "sinatra", require: false
gem "sidekiq"
gem "bcrypt"
gem "responders"
gem "jbuilder"
gem "omniauth-google-oauth2"
gem "aws-sdk"
gem "pundit"
gem "sass-rails"
gem "bootstrap-sass", "~> 3.3.6"
gem "uglifier"
gem "jquery-rails"
gem "turbolinks"
gem "sprockets", ">=3.4.0"
gem "sprockets-es6", require: "sprockets/es6"
gem "font-awesome-sass"

group :development, :test do
  gem "rubocop", require: false
  gem "ruby-prof", require: false
end

group :development do
  gem "pry-byebug"
  gem "better_errors"
  gem "railroady"
  gem "binding_of_caller"
end

group :test do
  gem "mocha", require: false
  gem "codeclimate-test-reporter", require: false
  gem "webmock"
end

group :production do
  gem "rails_12factor"
end
