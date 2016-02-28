class Subscription < ActiveRecord::Base
  belongs_to :user, inverse_of: :subscriptions
  belongs_to :handover, inverse_of: :subscriptions

  validates :user, :handover, presence: true
  validates :user, uniqueness: { scope: [:handover] }
end
