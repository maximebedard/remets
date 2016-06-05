require "sinatra/base"

module Remets
  module MockAmazonS3
    def before_setup
      stub_request(:any, /#{Bucket.url}/).to_rack(MockApp)
      super
    end

    class MockApp < Sinatra::Base
      get "/*" do
        filename = "#{Rails.root}/test/fixtures/files/#{params[:splat][0]}"
        return status(404) unless File.exist?(filename)

        send_file(filename)
      end
    end
  end
end
