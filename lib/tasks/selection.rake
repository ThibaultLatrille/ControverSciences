namespace :admin  do
  task :selection => :environment do
    include AssisstantHelper

    update_score_timelines
    update_all_profils
    compute_occurencies
  end
end