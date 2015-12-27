Minitest.after_run do
  FileUtils.rm_rf(Rails.root.join("test/fixtures/uploads"))
end
