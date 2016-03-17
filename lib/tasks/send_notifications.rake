namespace :admin  do
  task :send_notifications => :environment do
    controller = TasksController.new
    controller.send_patches
    controller.send_notifications
  end
end