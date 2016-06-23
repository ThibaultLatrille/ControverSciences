namespace :admin  do
  task :notifications => :environment do
    controller = TasksController.new
    controller.send_patches
    controller.send_notifications
    controller.notif_slack
  end
end