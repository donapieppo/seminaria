namespace :seminaria do
  namespace :users do

    desc "Create admin with mail. If dm_unibo_common.searchable_provider == true it verify the user existence"
    task create_admin: :environment do
      print "Provide e-mail of the admin user (gmail.com): "
      email = STDIN.gets.chomp

      u = User.find_or_syncronize(email)
    end

  end
end

