namespace :user do
  desc "Set a user as admin"
  task :set_admin, [:email] => :environment do |t, args|
    # rake user:set_admin\['user@example.com'\]
    user = User.find_by(email: args.email)
    if user
      user.update(admin: true)
      puts "User #{args.email} is now an admin."
    else
      puts "No user found with the email #{args.email}."
    end
  end
end