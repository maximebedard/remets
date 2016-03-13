class Organization < ActiveRecord::Base
  has_many :memberships, inverse_of: :organization, dependent: :destroy
  has_many :users, through: :memberships

  belongs_to :user

  accepts_nested_attributes_for :memberships

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
