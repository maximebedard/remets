require 'test_helper'

class FileUploaderTest < ActiveSupport::TestCase
  test '#filename uses a random hex'
  test '#filename is memoized'
  test '#store_dir returns the upload dir scoped to the model'
  test '#cache_dir returns the upload temp dir scoped to the model'
  test '#sanitized creates a sanitized version when the format is supported'
  test '#sanitized does not create a sanitized version when the format is unsupported'
end
