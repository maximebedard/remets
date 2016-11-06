class Submission < ApplicationRecord
  has_many :submitted_documents
  has_many :document_matches, through: :submitted_documents

  has_one :grade

  belongs_to :evaluation
  belongs_to :user

  accepts_nested_attributes_for :submitted_documents

  scope :for, -> (user) { where(user: user) }

  scope :similar_to, lambda { |reference|
    joins(:document_matches)
      .where.not(id: reference.id)
      .group(:id)
      .select("#{quoted_table_name}.*, (sum(document_matches.similarity) / count(documents.id)) as accuracy")
      .order("accuracy DESC")
  }

  validates(
    :submitted_documents,
    :evaluation,
    :user,
    presence: true,
  )

  def accuracy
    @accuracy = self[:accuracy].to_f if has_attribute?(:accuracy)
    @accuracy ||= 0.0
  end

  def compare_with(other)
    document_matches.where(compared_document_id: other.submitted_documents.ids)
  end

  def sanitizable_documents
    submitted_documents
  end
end
