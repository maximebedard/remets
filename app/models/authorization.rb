class Authorization < ActiveRecord::Base
  belongs_to :user

  validates(
    :user,
    :provider,
    :uid,
    :token,
    :secret,
    presence: true,
  )
end
