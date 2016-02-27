class Membership < ActiveRecord::Base
  belongs_to :user, inverse_of: :memberships, dependent: :destroy
  belongs_to :organization

  validates :user, :organization, presence: true
  validates :user, uniqueness: { scope: [:organization] }
end
