require Rails.root.join("test/support/fixture_upload_helper")

task :fingerprint_submissions do
  Submission.all.each { |s| Fingerprinter.new(s, {}).call }
end

task :fingerprint_handovers do
  Handover.all.each { |h| Fingerprinter.new(h, {}).call }
end

Rake::Task["db:fixtures:load"].enhance [
  :fingerprint_submissions,
  :fingerprint_handovers,
]
