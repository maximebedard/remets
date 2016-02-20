class Organization < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships

  belongs_to :user

  validates(
    :name,
    :user,
    :memberships,
    presence: true,
  )

  def leave(user)
    memberships.where(user: user).destroy_all
    destroy if memberships.blank?
  end
end
