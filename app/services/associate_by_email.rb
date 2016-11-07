class AssociateByEmail
  def initialize(record, emails, builder: RelationshipBuilders::Null.new)
    @record = record
    @emails = emails
    @builder = builder
  end

  def call(include_owner: false)
    relationships = []
    relationships += build_relationships
    relationships += build_relationship_for_owner if include_owner
    relationships
  end

  private

  attr_reader :record, :emails, :builder

  def build_relationships
    Array(emails).map do |email|
      builder.build(record, email)
    end
  end

  def build_relationship_for_owner
    [
      builder.build(record, record.user.email),
    ]
  end
end
