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

User.create!(name:  "Romain",
             email: "romanoferon@free.fr",
             password:              "controversciences",
             password_confirmation: "controversciences",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

50.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  email = "#{n+1}@univmontp2.org"
  password = "password"
  User.create!(name: "#{first_name} #{last_name}",
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take(10)
5.times do
  name  = Faker::Lorem.sentence(5)
  content = Faker::Lorem.sentence(8)
  users.each do |user|
    timeline = Timeline.new(
        user_id: user.id,
        name:  name,
        timeline_edit_content: content,
        rank: 4.2)
    timeline.save()
    10.times do |n|
      title  = Faker::Lorem.sentence(2)
      title_en  = Faker::Lorem.sentence(2)
      journal = 'Royal Society of'
      author = Faker::Name.name
      year = rand(1995..2005)
      doi = 'http://tinyurl.com/2g9mqh'
      reference=Reference.new( {
                   timeline_id: timeline.id,
                   user_id: user.id,
                   title: title,
                   title_en: title_en,
                   journal: journal,
                   author: author,
                   doi: doi,
                   year: year })
      reference.save()
    end
  end
end

users = User.all
users.each do |user|
  content = Faker::Lorem.sentence(8)
  field = rand(1..5)
  timeline = Reference.first.timeline
  timeline.update_attributes(rank: 10)
  comment=Comment.new(
        user_id: user.id,
        timeline_id:  timeline.id,
        reference_id: 1,
        field: field,
        content: content)
  comment.save()
end
