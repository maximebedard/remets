unless ENV["SECRET_KEY_BASE"]
  STDERR.puts "\e[31m=> Please load the environment secrets before running the test suite\e[0m"
  exit 1
end

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
