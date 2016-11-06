require "test_helper"

class FixturesConsistencyTest < ActiveSupport::TestCase
  include Remets::MockAmazonS3

  test "all fixtures are valid" do
    invalid_messages = []
    all_fixtures.each do |fixture_name, fixture|
      next if fixture["invalid_fixture"]

      validate_fixture(
        fixture,
        fixture_name,
        invalid_messages,
      )
    end
    assert invalid_messages.empty?, invalid_messages.sort.join("\n")
  end

  [
    SubmittedDocument,
    BoilerplateDocument,
    ReferenceDocument,
    GradedDocument,
  ].each do |klass|
    test "all #{klass.to_s.underscore} files exists" do
      invalid_messages = []
      klass.find_each do |document|
        validate_file(
          document,
          document.file,
          invalid_messages,
        )
      end
      assert invalid_messages.empty?, invalid_messages.sort.join("\n")
    end
  end

  [
    SubmittedDocument,
    BoilerplateDocument,
  ].each do |klass|
    test "all #{klass.to_s.underscore} sanitized files exists" do
      invalid_messages = []
      klass.find_each do |document|
        next unless document.sanitizable?

        validate_file(
          document,
          document.sanitized_file,
          invalid_messages,
        )
      end
      assert invalid_messages.empty?, invalid_messages.sort.join("\n")
    end
  end

  [
    SubmittedDocument,
    BoilerplateDocument,
  ].each do |klass|
    test "all #{klass.to_s.underscore} are fingerprinted" do
      invalid_messages = []
      klass.find_each do |document|
        validate_windows(document, invalid_messages)
      end
      assert invalid_messages.empty?, invalid_messages.sort.join("\n")
    end
  end

  [
    SubmittedDocument,
    BoilerplateDocument,
  ].each do |klass|
    test "all sanitizable files for #{klass.to_s.underscore} have the scrubbed content of the original file" do
      invalid_messages = []
      klass.find_each do |document|
        validate_sanitized_file(document, invalid_messages)
      end
      assert invalid_messages.empty?, invalid_messages.sort.join("\n")
    end
  end

  private

  def format_message(table_name, fixture_name, message)
    "  Fixture \e[33m#{table_name}(:#{fixture_name})\e[0m #{message}"
  end

  def all_fixtures
    ActiveRecord::FixtureSet.all_loaded_fixtures.flat_map do |_, fixture_set|
      fixture_set.fixtures.map { |fixture_name, fixture| [fixture_name, fixture] }
    end
  end

  def reverse_lookup(instance)
    ActiveRecord::FixtureSet.all_loaded_fixtures
      .select { |_, fixture_set| fixture_set.model_class == instance.class }
      .flat_map { |_, fixture_set| fixture_set.fixtures.keys }
      .detect do |key|
        ActiveRecord::FixtureSet.identify(key) == instance.id
      end
  end

  def validate_windows(document, messages = [])
    return unless document.fingerprintable?

    indexes, fingerprints = document.generate_windows.transpose
    indexes ||= [] # defaulted by postgres
    fingerprints ||= [] # defaulted by postgres

    table_name = document.class.table_name
    fixture_name = reverse_lookup(document)

    unless indexes == document.indexes
      messages << format_message(
        table_name,
        fixture_name,
        "indexes are not eql\n" \
        "  \e[32m + `#{indexes}`\e[0m\n" \
        "  \e[31m - `#{document.indexes}`\e[0m",
      )
    end

    unless fingerprints == document.fingerprints
      messages << format_message(
        table_name,
        fixture_name,
        "fingerprints are not eql\n" \
        "  \e[32m+ `#{fingerprints}`\e[0m\n" \
        "  \e[31m- `#{document.fingerprints}`\e[0m",
      )
    end
  end

  def validate_file(document, file, messages = [])
    unless file.exists?
      messages << format_message(
        document.class.table_name,
        reverse_lookup(document),
        "file \e[31m#{fixture_file_path(file)}\e[0m does not exists",
      )
    end
  end

  def validate_fixture(fixture, fixture_name, messages = [])
    klass = fixture.model_class
    record = klass.unscoped.find_by(klass.primary_key => fixture[klass.primary_key])

    if !record.present?
      messages << format_message(
        klass.table_name,
        fixture_name,
        "could not be found",
      )
    elsif !record.valid?(:update)
      messages << format_message(
        klass.table_name,
        fixture_name,
        "is not valid because: #{record.errors.full_messages.to_sentence}",
      )
    end
  rescue StandardError => e
    messages << format_message(
      klass.table_name,
      fixture_name,
      "caused an exception while testing validity: #{e.class}:#{e.message}",
    )
  end

  def validate_sanitized_file(document, messages = [])
    return unless document.sanitized?

    expected = document.generate_sanitized_content.strip
    actual = document.sanitized_file.read_content.strip

    unless expected == actual
      messages << format_message(
        document.class.table_name,
        reverse_lookup(document),
        "content of the sanitized document is not eql for #{fixture_file_path(document.sanitized_file)} \n" \
        "  \e[32m + `#{expected}`\e[0m\n" \
        "  \e[31m - `#{actual}`\e[0m",
      )
    end
  end

  def fixture_file_path(file)
    file.url.gsub(/#{Remets.aws_bucket.url}/, "test/fixtures/files")
  end
end
