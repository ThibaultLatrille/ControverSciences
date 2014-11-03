def seed_users
  users = []
  users << User.new(name:  "thibault",
               email: "thibault.latrille@ens-lyon.fr",
               password:              "password",
               password_confirmation: "password",
               admin: true,
               activated: true,
               activated_at: Time.zone.now)

  users << User.new(name:  "Romain",
               email: "romanoferon@free.fr",
               password:              "password",
               password_confirmation: "password",
               admin: true,
               activated: true,
               activated_at: Time.zone.now)

  30.times do |n|
    first_name  = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    email = "#{n+1}@edu.org"
    password = "password"
    users << User.new(name: "#{first_name} #{last_name}",
                 email: email,
                 password:              password,
                 password_confirmation: password,
                 activated: true,
                 activated_at: Time.zone.now)
  end
  users.map do |u|
    u.save
  end
  users
end

def seed_timelines(users)
  timelines = []
  names = []
  names << "Les OGMs sont-ils nocifs pour la santé ?"
  names << "Les chats vont-ils conquérir la terre ?"
  names << "Les ondes éléctromagnétiques sont elles dangeureuse ?"
  names << "Les animaux ne sont pas homosexuels ?"
  names << "Les poissons de Fukushima sont-ils fluorescent ?"
  names << "La masturbation rend elle sourd ?"
  names << "Les coraux vont-ils disparaître ?"
  names << "L'herbe rend elle con ?"
  names << "La café est il dangeureux ?"
  names << "Le LHC va-t-il créer un trou noir ?"
  names << "Yellowstone va bientôt sauter ?"

  content = Faker::Lorem.sentence(8)
  names.each do |name|
      timelines << Timeline.new(
      user: users[rand(users.length)],
      name:  name,
      timeline_edit_content: content,
      rank: 4.2)
  end
  timelines.map do |t|
    t.save
  end
  timelines
end

def seed_references(users, timelines)
  references = []
  bibtex = BibTeX.open('./db/seeds.bib')
  timelines.each do |timeline|
    array = Array((0..bibtex.length)).sample(5)
    array.each do |rand|
      bib = bibtex[rand]
      ref = Reference.new(
          user: users[rand(users.length)],
          timeline: timeline)
      reference_attributes = [:title, :doi, :year, :url, :journal, :author, :abstract]
      reference_attributes.each do |attr|
        ref[attr] = bib.respond_to?(attr) ? bib[attr].value : ''
      end
      ref.year = ref.year.to_i
      ref.title_fr = Faker::Lorem.sentence(4)
      references << ref
    end
  end
  references.map do |r|
    r.save
  end
  references
end

def seed_comments(users, timelines)
  comments = []
  timeline = timelines[0]
  references = timeline.references
  references.each do |ref|
    contributors = users.sample(users.length/2)
    contributors.each do |user|
      content = Faker::Lorem.sentence(8)
      field = rand(1..5)
      comments << Comment.new(
          user: user,
          timeline:  timeline,
          reference: ref,
          field: field,
          content: content)
    end
  end

  comments.map do |c|
    c.save
  end
  comments
end

users = seed_users
timelines = seed_timelines(users)
seed_references(users, timelines)
seed_comments(users, timelines)