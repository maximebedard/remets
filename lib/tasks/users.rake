namespace :users do
  task :promote do
    role = ENV["ROLE"] || "user"
    email = ENV["EMAIL"] || raise("EMAIL must be specified")

    User.find_by!(email: email).update!(role: role)
  end
end
