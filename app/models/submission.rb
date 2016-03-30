class Submission < ActiveRecord::Base
  has_many :documents
  has_many :document_matches, through: :documents

  belongs_to :handover
  belongs_to :user

  accepts_nested_attributes_for :documents

  scope :latests, lambda {
    select("distinct on(user_id) *")
      .order(:user_id, created_at: :desc)
  }

  scope :similar_to, lambda { |reference|
    joins(:document_matches)
      .where.not(id: reference.id)
      .group(:id)
      .select("#{quoted_table_name}.*, (sum(document_matches.similarity) / count(documents.id)) as accuracy")
      .order("accuracy DESC")
  }

  validates(
    :documents,
    :handover,
    :user,
    presence: true,
  )

  def accuracy
    @accuracy = self[:accuracy].to_f if has_attribute?(:accuracy)
    @accuracy ||= 0.0
  end

  def compare_with(other)
    document_matches.where(compared_document_id: other.documents.ids)
  end

  def fingerprintable_documents
    documents
  end
end
