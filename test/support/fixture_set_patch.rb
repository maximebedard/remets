class ActiveRecord::FixtureSet
  cattr_accessor :ignored_columns
  self.ignored_columns = ["invalid_fixture"]
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  def self.create_fixtures(fixtures_directory, fixture_set_names, class_names = {}, config = ActiveRecord::Base)
    fixture_set_names = Array(fixture_set_names).map(&:to_s)
    class_names = ClassCache.new class_names, config

    # FIXME: Apparently JK uses this.
    connection = block_given? ? yield : ActiveRecord::Base.connection

    files_to_read = fixture_set_names.reject do |fs_name|
      fixture_is_cached?(connection, fs_name)
    end

    unless files_to_read.empty?
      connection.disable_referential_integrity do
        fixtures_map = {}

        fixture_sets = files_to_read.map do |fs_name|
          klass = class_names[fs_name]
          conn = klass ? klass.connection : connection
          fixtures_map[fs_name] = new(
            conn,
            fs_name,
            klass,
            ::File.join(fixtures_directory, fs_name),
          )
        end

        update_all_loaded_fixtures fixtures_map

        connection.transaction(requires_new: true) do
          fixture_sets.each do |fs|
            conn = fs.model_class.respond_to?(:connection) ? fs.model_class.connection : connection
            table_rows = fs.table_rows

            table_rows.each_key do |table|
              conn.delete "DELETE FROM #{conn.quote_table_name(table)}", "Fixture Delete"
            end

            table_rows.each do |fixture_set_name, rows|
              rows.each do |row|
                conn.insert_fixture(row.except(*ignored_columns), fixture_set_name)
              end
            end

            # Cap primary key sequences to max(pk).
            if conn.respond_to?(:reset_pk_sequence!)
              conn.reset_pk_sequence!(fs.table_name)
            end
          end
        end

        cache_fixtures(connection, fixtures_map)
      end
    end
    cached_fixtures(connection, fixture_set_names)
  end
end
