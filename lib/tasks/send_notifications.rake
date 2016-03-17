namespace :admin  do
  task :send_notifications => :environment do
    controller = TasksController.new
    controller.send_patches
    if Time.now.day == 1 || Time.now.day == 16
      controller.send_notifications
    end
  end
end