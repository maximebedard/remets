# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password]

module LogWithBinaryTruncate
  protected

  TRUNCATE_LENGTH = 100
  TRUNCATE_COLUMNS = %w(indexes fingerprints)

  def log(sql, name = "SQL", binds = [], statement_name = nil, &block)
    b = binds.map do |k, v|
      if v.is_a?(String) && v.size > TRUNCATE_LENGTH && TRUNCATE_COLUMNS.include?(k.name)
        v = v.truncate(TRUNCATE_LENGTH)
      end
      [k, v]
    end

    super(sql, name, b, statement_name, &block)
  end
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(LogWithBinaryTruncate)
