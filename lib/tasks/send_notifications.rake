namespace :admin  do
  task :send_notifications => :environment do
    if Time.now.tuesday?
      controller = ApplicationController.new
      controller.send_notifications
    end
  end
end