module Remets
  module MockRemoteFile
    extend ActiveSupport::Concern

    included do
      setup :hijack_remote_file
      teardown :restore_remote_file
    end

    def self.with_mock
      hijack_remote_file
      yield
    ensure
      restore_remote_file
    end

    def hijack_remote_file
      @old_remote_file = Object.const_get(:RemoteFile)

      swap_const(:RemoteFile, MockedRemoteFile)
    end

    def restore_remote_file
      swap_const(:RemoteFile, @old_remote_file)
    end

    private

    def swap_const(a, b)
      Object.send(:remove_const, a)
      Object.const_set(a, b)
    end
  end

  class MockedRemoteFile
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def url
      "#{`hostname`}/s3_mock/#{key}"
    end

    def exists?
      File.exist?(path)
    end

    def content(*args)
      @content ||= File.read(key, *args)
    end

    private

    def path
      "#{Rails.root}/test/fixtures/files/#{key}"
    end
  end
end
