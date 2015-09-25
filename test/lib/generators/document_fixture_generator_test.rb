require 'test_helper'
require 'generators/document_fixture/document_fixture_generator'

class DocumentFixtureGeneratorTest < Rails::Generators::TestCase
  tests DocumentFixtureGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
