class Evaluation < ActiveRecord::Base
  has_many :reference_documents
  has_many :boilerplate_documents
  has_many :submissions
  has_many :subscriptions, inverse_of: :evaluation, dependent: :destroy
  has_many :users, through: :subscriptions

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

  scope :upcoming, -> { where("due_date > ?", Time.zone.now) }
  scope :past, -> { where("due_date < ?", Time.zone.now) }
  scope :latest_deadlines_first, -> { order("due_date asc") }

  accepts_nested_attributes_for :boilerplate_documents,
    :reference_documents

  def fingerprintable_documents
    boilerplate_documents
  end

  def completed?
    due_date < Time.zone.now || mark_as_completed.present?
  end

  def latest_submissions_for(user)
    submissions.where(user: user).order(created_at: :desc).first
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
