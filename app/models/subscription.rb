class Subscription < ActiveRecord::Base
  belongs_to :user, inverse_of: :subscriptions
  belongs_to :evaluation, inverse_of: :subscriptions

  validates :user, :evaluation, presence: true
  validates :user, uniqueness: { scope: [:evaluation] }
end
