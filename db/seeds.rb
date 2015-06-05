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
  users << User.new(name: "T. Latrille",
                    email: "thibault.latrille@controversciences.org",
                    password: "password",
                    password_confirmation: "password",
                    admin: true,
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "T. Lorin",
                    email: "thibault.lorin@ens-lyon.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "N. Clairis",
                    email: "nicolas.clairis@ens-lyon.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "M. Melix",
                    email: "marion.melix@ens-lyon.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "H. Pitsch",
                    email: "helmut.pitsch@irsn.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "A. Danet",
                    email: "Alain.Danet@univ-montp2.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "R. Feron",
                    email: "romain.feron@evobio.eu",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "Iago-lito",
                    email: "iago.bonnici@ens.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "Y. Anciaux",
                    email: "yoann.anciaux@univ-montp2.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "P. Guille Escuret",
                    email: "sombrenard@gmail.com",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "F. Lamouche",
                    email: "florian.lamouche@ens-lyon.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "S. Knipping",
                    email: "solene.knipping@ens-lyon.fr",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users << User.new(name: "N. Rivel",
                    email: "nais.rivel@gmail.com",
                    password: "password",
                    password_confirmation: "password",
                    activated: true,
                    activated_at: Time.zone.now)
  users.map do |u|
    u.save(validate: false)
  end
  users
end

def seed_timelines(users)
  timelines = []
  names = []
  names << "Les OGMs sont-ils nocifs pour la santé humaine ?"
  names << "Quels dangers pour les pilules de 3eme génération ?"
  names << "Les ondes des portables, quels dangers pour notre corps ?"
  names << "L'homosexualité chez les animaux."
  names << "Sommes nous des descendants de Néanderthal ?"
  names << "Le THC entraîne-t-il des changements neurologiques irréversibles ?"
  names << "L'homme a-t-il engendré des seismes ?"
  names << "Les vaccins et leurs effets secondaires"
  names << "Quotient intellectuel, quelle part de génétique ?"
  names << "Le vaccin de l'hépatite B, un lien avec la sclérose en plaque ?"
  names << "Les jeux vidéo rendent-ils violents ?"
  names << "Le point G, mythe ou réalité ?"
  names.each do |name|
    timeline = Timeline.new(
        user: users[0],
        name: name,
        score: 1)
    timelines << timeline
  end
  timelines.map do |t|
    t.save!
  end
  timelines
end

def seed_references(user, timeline_name, file_name, tags, binary, debate)
  timeline = Timeline.new(
      user: user,
      binary: binary,
      name: timeline_name,
      debate: debate,
      score: 1)
  timeline.set_tag_list(tags)
  timeline.save!
  timeline_url = "http://controversciences.org/timelines/"+timeline.id.to_s
  bibtex = BibTeX.open("./db/#{file_name}.bib")
  bibtex.each do |bib|
    puts bib[:title]
    puts bib[:content]
    if bib[:title]
      ref = Reference.new(
          user: user,
          timeline: timeline)
      reference_attributes = [:title, :doi, :year, :url, :journal, :author, :abstract]
      reference_attributes.each do |attr|
        ref[attr] = bib.respond_to?(attr) ? bib[attr].value : ''
      end
      ref.year = ref.year.to_i
      ref.open_access = bib[:open_access].value == "true" ? true : false
      ref.save!
      comment = Comment.new(
          user: user,
          timeline: timeline,
          reference: ref,
          title: bib.respond_to?(:f_6_content) ? bib[:f_6_content].value : '',
          f_0_content: bib.respond_to?(:f_0_content) ? bib[:f_0_content].value : '',
          f_1_content: bib.respond_to?(:f_1_content) ? bib[:f_1_content].value : '',
          f_2_content: bib.respond_to?(:f_2_content) ? bib[:f_2_content].value : '',
          f_3_content: bib.respond_to?(:f_3_content) ? bib[:f_3_content].value : '',
          f_4_content: bib.respond_to?(:f_4_content) ? bib[:f_4_content].value : '',
          f_5_content: bib.respond_to?(:f_5_content) ? bib[:f_5_content].value : '')
      comment.save_with_markdown(timeline_url)
      if comment.new_record?
        puts comment.valid?
        puts comment.title
        for i in 0..5 do
          puts "f_#{i}_content"
          puts comment["f_#{i}_content".to_sym].length
        end
      end
    elsif bib[:content]
      summary = Summary.new(
          user: user,
          timeline: timeline,
          content: bib.respond_to?(:content) ? bib[:content].value.to_s : '')
      summary.save_with_markdown(timeline_url)
      if summary.new_record?
        puts summary.valid?
        puts summary.content
      end
    end
  end
end

seed_domains
tags = tags_hash.keys
users = seed_users
seed_timelines(users)
seed_references(users[1], "La café est-il bénéfique pour la santé ?", "cafe", tags.sample(rand(1..7)), "Non&&Oui", true)
seed_references(users[1], "Les abeilles vont-elles disparaître ? ", "abeilles", tags.sample(rand(1..7)), "Non&&Oui", true)
seed_references(users[1], "L'homéopathie est-elle efficace ?", "homeopathie", tags.sample(rand(1..7)), "Non&&Oui", true)
# seed_references(users[2], "Peut-on contrôler le comportement par la technologie ?", "opto", tags.sample(rand(1..7)), "Non&&Oui", true)
# seed_references(users[3], "Viande rouge ou viande blanche, l'impact sur la santé ?", "meat", tags.sample(rand(1..7)), "", true)
