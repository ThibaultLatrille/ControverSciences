include ApplicationHelper

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

def seed_timelines(users, tags)
  timelines = []
  names = []
  names << "Les OGMs sont-ils nocifs pour la santé ?"
  names << "Les crevettes sont elles conscientes"
  names << "Les ondes des portables vont-elles nous griller le cerveau ?"
  names << "Les animaux peuvent-ils être homosexuels ?"
  names << "Les poissons de Fukushima sont-ils fluorescent ?"
  names << "Les poules ont elles des dents ?"
  names << "Sommes nous descendant de Néanderthal ? "
  names << "Le nuage de Tchernobyl s'est il arreté à la frontière "
  names << "La masturbation rend elle sourd ?"
  names << "Les coraux vont-ils disparaîtrent ?"
  names << "Le THC rend elle stupide et con ?"
  names << "La café est il mauvais pour la santé ?"
  names << "Le LHC va-t-il créer un trou noir ?"
  names << "Yellowstone va-il bientôt sauter ?"
  content = Faker::Lorem.sentence(8)
  names.each do |name|
      timeline = Timeline.new(
      user: users[rand(users.length)],
      name:  name,
      timeline_edit_content: content,
      score: 4.2)
      timeline.set_tag_list( tags.sample(rand(1..7)) )
      timelines << timeline
  end
  timelines.map do |t|
    t.save!
  end
  timelines
end

def seed_following_new_timelines(users, tags)
  following_new_timelines = []
  users.each do |user|
    s = tags.length
    tag_ids = Array(1..s).sample(rand(s+1))
    tag_ids.each do |tag_id|
      following_new_timelines << FollowingNewTimeline.new( user_id: user.id, tag_id: tag_id )
    end
  end
  following_new_timelines.map do |f|
    f.save!
  end
  following_new_timelines
end

def seed_following_timelines(users, timelines)
  following_timelines = []
  users.each do |user|
    user_timelines = timelines.sample(1+rand(timelines.length-1))
    user_timelines.each do |timeline|
      following_timelines << FollowingTimeline.new( user_id: user.id, timeline_id: timeline.id )
    end
  end
  following_timelines.map do |f|
    f.save!
  end
  following_timelines
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
      ref.open_access = rand(2) == 1 ? true : false
      references << ref
    end
  end
  references.map do |r|
    r.save!
  end
  references
end

def seed_following_references(users, references)
  following_references = []
  users.each do |user|
    user_references = references.sample(1+rand(references.length-1))
    user_references.each do |reference|
      following_references << FollowingReference.new( user_id: user.id, reference_id: reference.id )
    end
  end
  following_references.map do |f|
    f.save!
  end
  following_references
end

def seed_comments(users, timelines)
  root_url = "0.0.0.0:3000/"
  comments = []
  timeline = timelines[0]
  references = timeline.references
  references.each do |ref|
    contributors = users[1..-1].sample(1+rand(users.length/2-1))
    contributors << users[0]
    contributors.each do |user|
      f_1_content = Faker::Lorem.sentence(rand(12))+"\n"+Faker::Lorem.sentence(rand(8))
      f_2_content = Faker::Lorem.sentence(rand(12))+"\n"+Faker::Lorem.sentence(rand(8))
      f_3_content = Faker::Lorem.sentence(rand(12))+"\n"+Faker::Lorem.sentence(rand(8))
      f_4_content = Faker::Lorem.sentence(rand(12))+"\n"+Faker::Lorem.sentence(rand(8))
      f_5_content = Faker::Lorem.sentence(rand(12))+"\n"+Faker::Lorem.sentence(rand(8))
      comment = Comment.new(
          user: user,
          timeline:  timeline,
          reference: ref,
          f_1_content: f_1_content,
          f_2_content: f_2_content,
          f_3_content: f_3_content,
          f_4_content: f_4_content,
          f_5_content: f_5_content)
      comments << comment
    end
  end
  comments.map do |c|
    c.save_with_markdown( root_url )
  end
  comments
end

def seed_votes(users, comments)
  votes = []
  users.each do |user|
    comments.group_by{ |c| c.reference_id }.each do |_, comments_by_reference|
      sum = 0
      comments_user = comments_by_reference.sample(rand(comments_by_reference.length/2))
      comments_user.each do |comment|
        value = rand(0..(12-sum))
        sum += value
        votes << Vote.new(
            user_id: user.id,
            comment_id: comment.id,
            timeline_id:  comment.timeline_id,
            reference_id: comment.reference_id,
            value: value)
      end
    end
  end
  votes.map do |v|
    v.save
  end
  votes
end

def seed_ratings(users, references)
  ratings = []
  references.each do |ref|
    voters = users.sample(1+rand(users.length-1))
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

tags = tags_hash.keys
users = seed_users
seed_following_new_timelines(users, tags)
timelines = seed_timelines(users, tags)
seed_following_timelines(users, timelines)
references = seed_references(users, timelines)
seed_following_references(users, references[0..4])
comments = seed_comments(users, timelines)
seed_votes(users, comments)
seed_ratings(users, references)