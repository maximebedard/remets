require "active_record/fixtures"
require Rails.root.join("test/support/fixtures_helper")

namespace :cache do
  task purge: :environment do
    [DocumentMatch, Match].each(&:destroy_all)
  end

  task build: :environment do
    (Submission.all + Evaluation.all).each do |i|
      Fingerprinter.new(i).call
    end
  end

  task :rebuild, [:purge, :build]

  # Extend db:fixtures:load to use our custom fixtures helpers
  # and build the cache dynamically.
  Rake::Task["db:fixtures:load"].enhance ["cache:purge"] do
    Rake::Task["cache:build"].invoke
  end
end
