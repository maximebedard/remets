class Handover < ActiveRecord::Base
  has_many :reference_documents
  has_many :boilerplate_documents
  has_many :submissions

  belongs_to :user
  belongs_to :organization

  before_validation :generate_uuid, on: :create

  validates(
    :uuid,
    :title,
    :description,
    :due_date,
    presence: true,
  )

  accepts_nested_attributes_for :boilerplate_documents,
    :reference_documents

  def fingerprintable_documents
    boilerplate_documents
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
