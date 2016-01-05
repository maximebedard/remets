require "active_record/fixtures"
require Rails.root.join("test/support/fixture_upload_helper")

namespace :rebuild_cache do
  task :prepare do
    Rails.application.eager_load!
    puts "Cleaning up cache..."

    DocumentMatch.destroy_all
    Match.destroy_all
  end

  task :cache do
    Submission.all.each { |s| Fingerprinter.new(s).call }
    Handover.all.each { |h| Fingerprinter.new(h).call }

    puts "Rebuilding cache..."
  end

  Rake::Task["db:fixtures:load"].enhance ["rebuild_cache:prepare"] do
    Rake::Task["rebuild_cache:cache"].invoke
  end
end
