namespace :admin  do
  task :send_notifications => :environment do
    controller = ApplicationController.new
    controller.send_notifications
  end
end