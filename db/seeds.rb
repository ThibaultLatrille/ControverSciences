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
    u.save!
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
  tags = %w(chemistry biology physics economy planet social immunity pharmacy animal plant space pie)
  content = Faker::Lorem.sentence(8)
  names.each do |name|
      timeline = Timeline.new(
      user: users[rand(users.length)],
      name:  name,
      timeline_edit_content: content,
      rank: 4.2)
      timeline.set_tag_list( tags.sample(rand(1..7)) )
      timelines << timeline
  end
  timelines.map do |t|
    t.save!
  end
  timelines
end

def seed_references(users, timelines)
  references = []
  bibtex = BibTeX.open('./db/seeds.bib')
  timelines.each do |timeline|
    array = Array((0..bibtex.length-1)).sample(5)
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
    r.save!
  end
  references
end

def seed_comments(users, timelines)
  root_url = "0.0.0.0:3000/"
  comments = []
  timeline = timelines[0]
  references = timeline.references
  references.each do |ref|
    contributors = users[1..-1].sample(rand(users.length/2))
    contributors << users[0]
    contributors.each do |user|
      content = Faker::Lorem.sentence(6)+"\n"+Faker::Lorem.sentence(4)
      field = rand(1..5)
      comment = Comment.new(
          user: user,
          timeline:  timeline,
          reference: ref,
          field: field,
          content: content)
      comment.markdown (root_url)
      comments << comment
    end
  end
  comments.map do |c|
    c.save!
  end
  comments
end

def seed_votes(users, comments)
  votes = []
  comments.group_by{ |c| c.reference_id }.each do |reference_id, comments_by_reference|
    comments_by_reference.group_by{ |c| c.field }.each do |field, comments_by_reference_field|
      voters = users.sample(rand(users.length))
      voters.each do |user|
        value = rand(0..1)
        comment = comments_by_reference_field[rand(comments_by_reference_field.length)]
        votes << Vote.new(
            user: user,
            comment: comment,
            timeline:  comment.timeline,
            reference_id: reference_id,
            field: field,
            value: value)
      end
    end
  end
  votes.map do |v|
    v.save!
  end
  votes
end

def seed_ratings(users, references)
  ratings = []
  references.each do |ref|
    voters = users.sample(rand(users.length))
    voters.each do |user|
      value = rand(1..5)
      ratings << Rating.new(
          user: user,
          timeline:  ref.timeline,
          reference: ref,
          value: value)
    end
  end
  ratings.map do |r|
    r.save!
  end
  ratings
end

def seed_meliorations(users, comments)
  user = users[0]
  user_comments = comments.select{ |c| c.user_id == user.id }
  meliorations = []
  user_comments.each do |com|
    contributors = users[1..-1].sample(rand(users.length))
    contributors.each do |contributor|
      content = com.content.dup
      content.insert(rand(content.length), Faker::Lorem.sentence(2))
      message = Faker::Lorem.sentence(10)
      meliorations << Melioration.new(
          to_user_id: user.id,
          user_id: contributor.id,
          content:  content,
          message: message,
          comment_id: com.id)
    end
  end
  all_other_comments = comments.select{ |c| c.user_id != user.id }
  other_comments = all_other_comments.sample(rand(all_other_comments.length))
  other_comments.each do |com|
    content = com.content.dup
    content.insert(rand(content.length), Faker::Lorem.sentence(2))
    message = Faker::Lorem.sentence(10)
    meliorations << Melioration.new(
        to_user_id: com.user_id,
        user_id: user.id,
        content:  content,
        message: message,
        comment_id: com.id)
  end
  meliorations.map do |r|
    r.save!
  end
  meliorations
end

users = seed_users
timelines = seed_timelines(users)
references = seed_references(users, timelines)
comments = seed_comments(users, timelines)
seed_votes(users, comments)
seed_ratings(users, references)
seed_meliorations(users, comments)