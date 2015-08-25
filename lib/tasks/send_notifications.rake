namespace :admin  do
  task :send_notifications => :environment do
    if Time.now.day == 1 || Time.now.day == 16
      controller = ApplicationController.new
      controller.send_notifications
    end
  end
end