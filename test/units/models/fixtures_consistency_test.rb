require "test_helper"

class FixturesConsistencyTest < ActiveSupport::TestCase
  test "all fixtures are valid" do
    skip

    invalid_messages = []
    all_fixtures.each do |fixture_name, fixture|
      klass = fixture.model_class
      table_name = klass.table_name
      next if fixture["invalid_fixture"]

      begin
        record = klass.unscoped.where(klass.primary_key => fixture[klass.primary_key]).first

        if !record.present?
          invalid_messages << format_message(
            table_name,
            fixture_name,
            "could not be found",
          )
        elsif !record.valid?(:update)
          invalid_messages << format_message(
            table_name,
            fixture_name,
            "is not valid because: #{record.errors.full_messages.to_sentence}",
          )
        end
      rescue StandardError => e
        invalid_messages << format_message(
          table_name,
          fixture_name,
          "caused an exception while testing validity: #{e.class}:#{e.message}",
        )
      end
    end
    assert invalid_messages.empty?, invalid_messages.sort.join("\n")
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
end
