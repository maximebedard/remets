namespace :users do
  AVAILABLE_ROLES = %w(user admin)

  task promote: :environment do
    role = ENV["ROLE"] || "admin"
    email = ENV["EMAIL"] || raise("EMAIL must be specified")

    raise("ROLE must be #{AVAILABLE_ROLES.join(',')}") unless AVAILABLE_ROLES.include?(role)
    raise("User with email #{email} does not exists.") unless user = User.find_by(email: email)

    user.update!(role: role)
  end
end
