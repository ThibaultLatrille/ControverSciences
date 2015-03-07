include ApplicationHelper

def list_domains
  %w(cnrs irstea ifsttar ined inria inra inserm ird crasc ens ecp ec-lyon.fr ec-lille.fr
    ec-nantes.fr insa ifremer brgm onf andra cea cemagref ineris irsn cnes cirad universcience
    mnhn.fr ehess.fr sorbonne.fr ensam.fr enssib.fr jussieu.fr sciences-po.fr obspm.fr palais-decouverte.fr
    ecp.fr inalco.fr dauphine.fr cnam.fr college-de-france.fr unistra.fr uha.fr u-bordeaux1.fr u-bordeaux3.fr
    u-bordeaux4.fr u-bordeaux2.fr univ-pau.fr lacc.univ-bpclermont.fr u-clermont1.fr univ-rennes1.fr
    univ-rennes2.fr univ-brest.fr univ-ubs.fr univ-orleans.fr univ-tours.fr univ-reims.fr univ-corse.fr
    fcomte.fr univ-paris1.fr u-paris2.fr univ-paris3.fr paris-sorbonne.fr univ-paris5.fr upmc.fr
    univ-paris-diderot.fr icp.fr univ-paris8.fr u-paris10.fr u-pec.fr univ-paris13.fr univ-mlv.fr u-cergy.fr
    uvsq.fr univ-evry.fr u-psud.fr univ-montp1.fr univ-montp2.fr univ-montp3.fr unimes.fr univ-perp.fr im.fr
    univ-metz.fr uhp-nancy.fr univ-nancy2.fr univ-tlse1.fr univ-tlse2.fr ups-tlse.fr ict-toulouse.asso.fr
    univ-jfc.fr univ-artois.fr univ-lille1.fr univ-lille2.fr univ-lille3.fr univ-catholille.fr univ-littoral.fr
    valenciennes.fr unicaen.fr univ-lehavre.fr univ-rouen.fr univ-angers.fr uco.fr univ-lemans.fr univ-nantes.fr
    u-picardie.fr utc univ-larochelle.fr univ-poitiers.fr univ-provence.fr univmed.fr univ-cezanne.fr
    univ-avignon.fr unice.fr univ-tln.fr univ-savoie.fr ujf-grenoble.fr upmf-grenoble.fr u-grenoble3.fr
    univ-lyon1.fr univ-lyon2.fr univ-lyon3.fr univ-catholyon.fr univ-st-etienne.fr univ-ag.fr
    univ-reunion ufp.pf unvi-nc.nc evobio epfl.ch controversciences.org)
end

def seed_domains
  list_domains.each do |domain_name|
    Domain.create(name: domain_name)
  end
end

def seed_users
  users = []
  users << User.new(name:  "T. Latrille",
               email: "thibault.latrille@controversciences.org",
               password:              "password",
               password_confirmation: "password",
               admin: true,
               activated: true,
               activated_at: Time.zone.now)
  users << User.new(name:  "T. Lorin",
                    email: "thibault.lorin@ens-lyon.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "N. Clairis",
                    email: "nicolas.clairis@ens-lyon.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "F. Figon",
                    email: "florent.figon@ens-lyon.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "R. Feron",
                    email: "romain.feron@evobio.eu",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "Iago-lito",
                    email: "iago.bonnici@ens.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "A. Danet",
                    email: "Alain.Danet@univ-montp2.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "Y. Anciaux",
                    email: "yoann.anciaux@univ-montp2.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "P. Guille Escuret",
                    email: "paul.guilleescuret@ens-lyon.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "A. Zidane",
                    email: "anthony.zidane@ens-lyon.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "F. Lamouche",
                    email: "florian.lamouche@ens-lyon.fr",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name:  "N. Rivel",
                    email: "nais.rivel@gmail.com",
                    password:              "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users.map do |u|
    u.save( validate: false)
  end
  users
end

def seed_timelines(users, tags)
  timelines = []
  names = []
  names << "Quel lien entre la prise de risque d'un individu et son statut hiérarchique dans la société?"
  names << "Quels sont les effets des OGMs sur la santé humaine ?"
  names << "Quelles conséquences des quotas laitiers ?"
  names << "Quels dangers pour les pilules de 3eme génération ?"
  names << "Les ondes des portables, quels dangers pour notre corps ?"
  names << "L'homosexualité chez les animaux."
  names << "La production de cacao peut-t-elle répondre à la demande de chocolat ?"
  names << "Sommes nous des descendants de Néanderthal ?"
  names << "Le THC entraîne-t-il des changements neurologiques irréversibles?"
  names << "Viande rouge ou viande blanche, l'impact sur la santé ?"
  names << "L'homme peut-il habiter sur une autre planète ?"
  names << "L'homme a-t-il engendré des seismes ?"
  names << "Les vaccins et leurs effets secondaires"
  names << "Replantons nous plus d'arbre que l'on en coupe ?"
  names << "Quotient intellectuel, quelle part de génétique ?"
  names << "Les vaches détectent-elles le champ magnétique terrestre ?"
  names << "Le vaccin de l'hépatite B, un lien avec la sclérose en plaque ?"
  names << "Les liens entre jeux vidéo et violence chez les enfants ?"
  names << "La théorie du genre"
  names << "Quelles conséquences a eu l'accident Tchernobyl ?"
  names << "Le point G, mythe ou réalité ?"
  names.each do |name|
      timeline = Timeline.new(
      user: users[rand(users.length)],
      name:  name,
      score: 1)
      timeline.set_tag_list( tags.sample(rand(1..7)) )
      timelines << timeline
  end
  timelines.map do |t|
    t.save!
  end
  timelines
end

def seed_following_new_timelines(users)
  following_new_timelines = []
  users = [users[0]]
  users.each do |user|
    tags = Tag.all
    tags.each do |tag|
      following_new_timelines << FollowingNewTimeline.new( user_id: user.id, tag_id: tag.id )
    end
  end
  following_new_timelines.map do |f|
    f.save!
  end
  following_new_timelines
end

def seed_following_timelines(users)
  following_timelines = []
  users = [users[0]]
  users.each do |user|
    user_timelines = Timeline.all
    user_timelines.each do |timeline|
      following_timelines << FollowingTimeline.new( user_id: user.id, timeline_id: timeline.id )
    end
  end
  following_timelines.map do |f|
    f.save!
  end
  following_timelines
end


def seed_following_summaries(users)
  following_summaries = []
  users = [users[0]]
  users.each do |user|
    user_timelines = Timeline.all
    user_timelines.each do |timeline|
      following_summaries << FollowingSummary.new( user_id: user.id, timeline_id: timeline.id )
    end
  end
  following_summaries.map do |f|
    f.save!
  end
  following_summaries
end

def seed_references(user, timeline_name, file_name, tags, binary)
  timeline = Timeline.new(
      user: user,
      binary: binary,
      name:  timeline_name,
      score: 1)
  timeline.set_tag_list( tags )
  timeline.save!
  timeline_url = "http://controversciences.org/timelines/"+timeline.id.to_s
  bibtex = BibTeX.open("./db/#{file_name}.bib")
  bibtex.each do |bib|
      ref = Reference.new(
          user: user,
          timeline: timeline)
      reference_attributes = [:title, :doi, :year, :url, :journal, :author, :abstract, :title_fr]
      reference_attributes.each do |attr|
        ref[attr] = bib.respond_to?(attr) ? bib[attr].value : ''
      end
      ref.year = ref.year.to_i
      ref.open_access = bib[:open_access].value == "true" ? true : false
      ref.save!
      comment = Comment.new(
          user: user,
          timeline:  timeline,
          reference: ref,
          f_0_content: bib.respond_to?(:f_0_content) ? bib[:f_0_content].value : '',
          f_1_content: bib.respond_to?(:f_1_content) ? bib[:f_1_content].value : '',
          f_2_content: bib.respond_to?(:f_2_content) ? bib[:f_2_content].value : '',
          f_3_content: bib.respond_to?(:f_3_content) ? bib[:f_3_content].value : '',
          f_4_content: bib.respond_to?(:f_4_content) ? bib[:f_4_content].value : '',
          f_5_content: bib.respond_to?(:f_5_content) ? bib[:f_5_content].value : '')
      comment.save_with_markdown( timeline_url )
    if comment.new_record?
      puts comment.valid?
      puts comment.reference.title_fr
      for i in 0..5 do
        puts "f_#{i}_content"
        puts comment["f_#{i}_content".to_sym].length
      end
    end
  end
end

def seed_following_references(users)
  following_references = []
  users = [users[0]]
  users.each do |user|
    user_references = Reference.all
    user_references.each do |reference|
      following_references << FollowingReference.new( user_id: user.id, reference_id: reference.id )
    end
  end
  following_references.map do |f|
    f.save!
  end
  following_references
end

def seed_summaries(users, timelines)
  summaries = []
  timeline = timelines[0]
  timeline_url = "http://controversciences.org/timelines/"+timeline.id.to_s
  contributors = [users[0]]
  contributors += users[1..-1].sample(1+rand(users.length))
  references = timeline.references
  reference_ids = references.map{ |ref| ref.id }
  contributors.each do |user|
    content = Faker::Lorem.sentence(1+rand(60))+"["+Faker::Lorem.sentence(rand(2))+"]("+
        reference_ids[rand(reference_ids.length)].to_s+")"+Faker::Lorem.sentence(rand(4))+
    "\n"+Faker::Lorem.sentence(rand(120))
    summary = Summary.new(
        user: user,
        timeline:  timeline,
        content: content)
    summaries << summary
  end
  summaries.map do |c|
    c.save_with_markdown( timeline_url )
  end
  summaries
end

def seed_credits(users, summaries)
  credits = []
  users.each do |user|
    summaries.group_by{ |c| c.timeline_id }.each do |_, summaries_by_timelines|
      sum = 0
      summaries_user = summaries_by_timelines.sample(rand(summaries_by_timelines.length/2))
      summaries_user.each do |summary|
        value = rand(0..(12-sum))
        if value > 0
          sum += value
          credits << Credit.new(
              user_id: user.id,
              summary_id: summary.id,
              timeline_id:  summary.timeline_id,
              value: value)
          visit = VisiteTimeline.find_by( user_id: user.id, timeline_id: summary.timeline_id )
          if visit
            visit.update( updated_at: Time.zone.now )
          else
            VisiteTimeline.create( user_id: user.id, timeline_id: summary.timeline_id )
          end
        end
      end
    end
  end
  credits.map do |v|
    v.save
  end
  credits
end

def seed_comments(users, timelines)
  comments = []
  timeline = timelines[0]
  timeline_url = "http://controversciences.org/timelines/"+timeline.id.to_s
  references = timeline.references
  reference_ids = references.map{ |ref| ref.id }
  references.each do |ref|
    contributors = users[1..-1].sample(1+rand(users.length/2-1))
    contributors << users[0]
    contributors.each do |user|
      f_1_content = Faker::Lorem.sentence(1+rand(16))+"["+Faker::Lorem.sentence(rand(2))+"]("+
          reference_ids[rand(reference_ids.length)].to_s+")"+Faker::Lorem.sentence(rand(4))
          "\n"+Faker::Lorem.sentence(1+rand(20))
      f_2_content = Faker::Lorem.sentence(rand(26))+"["+Faker::Lorem.sentence(rand(2))+"]("+
          reference_ids[rand(reference_ids.length)].to_s+")"+Faker::Lorem.sentence(rand(4))
      "\n"+Faker::Lorem.sentence(rand(12))
      f_3_content = Faker::Lorem.sentence(1+rand(25))+"["+Faker::Lorem.sentence(rand(2))+"]("+
          reference_ids[rand(reference_ids.length)].to_s+")"+Faker::Lorem.sentence(rand(4))
      "\n"+Faker::Lorem.sentence(rand(36))
      f_4_content = Faker::Lorem.sentence(1+rand(85))+"["+Faker::Lorem.sentence(rand(2))+"]("+
          reference_ids[rand(reference_ids.length)].to_s+")"+Faker::Lorem.sentence(rand(4))
      "\n"+Faker::Lorem.sentence(rand(42))
      f_5_content = Faker::Lorem.sentence(1+rand(6))+"["+Faker::Lorem.sentence(rand(2))+"]("+
          reference_ids[rand(reference_ids.length)].to_s+")"+Faker::Lorem.sentence(rand(4))
      "\n"+Faker::Lorem.sentence(rand(30))
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
    c.save_with_markdown( timeline_url )
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
        if value > 0
          sum += value
          votes << Vote.new(
              user_id: user.id,
              comment_id: comment.id,
              timeline_id:  comment.timeline_id,
              reference_id: comment.reference_id,
              value: value)
          visit = VisiteReference.find_by( user_id: user.id, reference_id: comment.reference_id )
          if visit
            visit.update( updated_at: Time.zone.now )
          else
            VisiteReference.create( user_id: user.id, reference_id: comment.reference_id )
          end
        end
      end
    end
  end
  votes.map do |v|
    v.save
  end
  votes
end

def seed_ratings(users, timelines)
  timeline = timelines[0]
  references = timeline.references
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

def seed_suggestions
  suggestions = []
  30.times do
    first_name  = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    suggestions << Suggestion.new(
        name: "#{first_name[0].upcase}. #{last_name}",
        comment: Faker::Lorem.sentence(1+rand(30))
    )
  end
  suggestions.map do |r|
    r.save!
  end
  suggestions
end

def seed_suggestion_children( suggestions )
  children = []
  suggestions.each do |suggestion|
    (1+rand(10)).times do
      first_name  = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      children << SuggestionChild.new(
          suggestion_id: suggestion.id,
          name: "#{first_name[0].upcase}. #{last_name}",
          comment: Faker::Lorem.sentence(1+rand(30))
      )
    end
  end
  children.map do |r|
    r.save!
  end
  children
end

seed_domains
tags = tags_hash.keys
users = seed_users
seed_timelines(users, tags)
seed_following_new_timelines(users)
seed_references(users[1], "La café est-il bénéfique pour la santé ?", "cafe", tags.sample(rand(1..7)), "Non && Oui")
seed_references(users[1], "Les abeilles vont-elles disparaître ? ", "abeilles", tags.sample(rand(1..7)), "Non && Oui")
seed_references(users[1], "L'homéopathie est-elle efficace ?", "homeopathie", tags.sample(rand(1..7)), "Non && Oui")
seed_references(users[2], "Peut-on contrôler le comportement par la technologie ?", "opto", tags.sample(rand(1..7)), "Non && Oui")
seed_following_timelines(users)
seed_following_summaries(users)
seed_following_references(users)
# summaries = seed_summaries(users, timelines)
# seed_credits(users, summaries)
# comments = seed_comments(users, timelines)
# seed_votes(users, comments)
# seed_ratings(users, timelines)
# suggestions = seed_suggestions
# seed_suggestion_children( suggestions )
