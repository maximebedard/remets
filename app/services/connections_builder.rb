class ConnectionsBuilder
  def initialize(record, emails, provider: ConnectionsProviders::NullProvider.new)
    @record = record
    @emails = emails
    @provider = provider
  end

  def call(include_owner: false)
    memberships = []
    memberships += build_connections
    memberships += build_connection_for_owner if include_owner
    memberships
  end

  private

  attr_reader :record, :emails, :provider

  def build_connections
    Array.wrap(emails).map do |email|
      provider.build(record, email)
    end
  end

  def build_connection_for_owner
    [
      provider.build(record, record.user.email),
    ]
  end
end
