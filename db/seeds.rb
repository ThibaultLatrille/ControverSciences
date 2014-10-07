# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name:  "thibault",
             email: "thibault.latrille@ens-lyon.fr",
             password:              "tiboln",
             password_confirmation: "tiboln",
	     admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take(2)
50.times do
  name  = Faker::Name.name
  users.each { |user| user.timelines.create!(name:  name,
               timeline_edit_content:  "du contenu",
               rank: 4.2) }
end
