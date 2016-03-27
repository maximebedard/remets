class Submission < ActiveRecord::Base
  has_many :documents

  belongs_to :handover
  belongs_to :user

  accepts_nested_attributes_for :documents

  scope :latests, lambda {
    select("distinct on(user_id) *")
      .order(:user_id, created_at: :desc)
  }

  validates(
    :documents,
    presence: true,
  )

  def fingerprintable_documents
    documents
  end
end
