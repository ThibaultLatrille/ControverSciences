namespace :admin  do
  task :notifications => :environment do
    include AssisstantHelper

    generate_notifications
  end
end