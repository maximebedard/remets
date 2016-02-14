class Organization < ActiveRecord::Base
  has_many :user_organizations
  has_many :users, through: :user_organizations

  belongs_to :user

  validates(
    :name,
    :user,
    :user_organizations,
    presence: true,
  )

  def leave(user)
    user_organizations.where(user: user).destroy_all
    destroy if user_organizations.blank?
  end
end
