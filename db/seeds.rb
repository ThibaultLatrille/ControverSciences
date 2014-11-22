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
  users.each do |user|
    comments_user = comments.sample(rand(comments.length))
    comments_user.each do |comment|
      value = rand(0..1)
      votes << Vote.new(
          user_id: user.id,
          comment_id: comment.id,
          timeline_id:  comment.timeline_id,
          reference_id: comment.reference_id,
          field: comment.field,
          value: value)
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

def seed_children(users, comments)
  root_url = "0.0.0.0:3000/"
  user = users[0]
  user_comments = comments.select{ |c| c.user_id == user.id }
  children = []
  user_comments.each do |com|
    contributors = users[1..-1].sample(1+rand(users.length-2))
    contributors.each do |contributor|
      content = com.content.dup
      content.insert(rand(content.length), Faker::Lorem.sentence(2))
      new_comment = Comment.new(
          user_id: contributor.id,
          timeline_id:  com.timeline_id,
          reference_id: com.reference_id,
          field: com.field,
          content: content)
      new_comment.markdown (root_url)
      new_comment.save!
      children << CommentRelationship.new( parent_id: com.id, child_id: new_comment.id)
    end
  end
  children.map do |r|
    r.save!
  end
  children
end

tags = tags_hash.keys
users = seed_users
seed_following_new_timelines(users, tags)
timelines = seed_timelines(users, tags)
seed_following_timelines(users, timelines)
references = seed_references(users, timelines)
seed_following_references(users, references[0..4])
comments = seed_comments(users, timelines)
seed_children(users, comments)
seed_votes(users, comments)
seed_ratings(users, references)