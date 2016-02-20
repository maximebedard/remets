class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :handover

  validates :user, :handover, presence: true
  validates :user, uniqueness: { scope: [:handover] }
end
