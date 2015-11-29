module AssisstantHelper

  def anonymize_data
    ActiveRecord::Base.transaction do
      User.find_each do |user|
        user.name = Faker::Name.name
        user.email = Faker::Internet.email
        user.password = SecureRandom.hex
        user.password_confirmation = user.password
        user.activated = true
        user.save!
      end
      admin = User.first
      admin.name = "Administrator"
      admin.email = "administrator@controversciences.org"
      admin.password = "password"
      admin.password_confirmation = "password"
      admin.save!
      Comment.where( public: false).destroy_all
      Summary.where( public: false).destroy_all
      Timeline.where( private: true).destroy_all
    end
  end

  def update_all_profils
    max = {1 => 0.0, 2 => 0.0, 3 => 0.0, 4 => 0.0, 5 => 0.0, 6 => 0.0, 7 => 0.0, 8 => 0.0, 9 => 0.0 }
    UserDetail.find_each do |user_detail|
      user_detail.profil = {}
      count = Timeline.where(user_id: user_detail.user_id ).count
      user_detail.profil[1] = count > 0 ? Timeline.where(user_id: user_detail.id ).sum(:score) / count : count
      count = Frame.where(user_id: user_detail.user_id ).count
      user_detail.profil[2] = count > 0 ? Frame.where( user_id: user_detail.user_id ).sum(:score) / count : count
      count = Summary.where(user_id: user_detail.user_id ).count
      user_detail.profil[3] =  count > 0 ? Summary.where(user_id: user_detail.user_id ).sum(:score) / count : count
      count = Reference.where(user_id: user_detail.user_id ).count
      user_detail.profil[4] = count > 0 ? Reference.where(user_id: user_detail.user_id ).sum(:star_most) / count : count
      count =  Comment.where(user_id: user_detail.user_id ).count
      if count > 0
        query = Comment.where(user_id: user_detail.user_id )
        score  = query.sum(:f_0_score) + query.sum(:f_1_score) + query.sum(:f_2_score) + query.sum(:f_3_score) +
            query.sum(:f_4_score) + query.sum(:f_5_score) + query.sum(:f_6_score) + query.sum(:f_7_score)
        user_detail.profil[5] =  score / count
      else
        user_detail.profil[5] = 0.0
      end
      user_detail.profil[6] = Float(Like.where(user_id: user_detail.user_id ).count)
      query = Comment.where(user_id: user_detail.user_id )
      balance  = query.sum(:f_0_balance) + query.sum(:f_1_balance) + query.sum(:f_2_balance) + query.sum(:f_3_balance) +
          query.sum(:f_4_balance) + query.sum(:f_5_balance) + query.sum(:f_6_balance) + query.sum(:f_7_balance)
      user_detail.profil[7] = Float(Summary.where(user_id: user_detail.user_id ).sum(:balance) +
          Frame.where(user_id: user_detail.user_id ).sum(:balance) + balance)
      user_detail.profil[8] = Float(Credit.where(user_id: user_detail.user_id ).count +
          FrameCredit.where(user_id: user_detail.user_id ).count +
          Vote.where(user_id: user_detail.user_id ).count)
      user_detail.profil[9] = User.find( user_detail.user_id).my_patches
      max.keys.each do |key|
        max[key] = (max[key] > user_detail.profil[key]) ? max[key] : user_detail.profil[key]
      end
      user_detail.save
    end
    UserDetail.all.each do |user_detail|
      max.keys.each do |key|
        if max[key] > 0
          user_detail.profil[key.to_s] = Float(user_detail.profil[key.to_s]) / max[key]
        else
          user_detail.profil[key.to_s] = 0.0
        end
      end
      user_detail.update_columns(profil: user_detail.profil)
    end
  end

  def update_score_users
    User.select(:id, :slug, :score).find_each do |user|
      count = 1
      for field in 0..7 do
        count += BestComment.where("f_#{field}_user_id".to_sym => user.id).count
      end
      score_comments   = 2*Math.log(count)
      score_summaries  = 10*Math.log(SummaryBest.where(user_id: user.id).count + 1)
      score_references = 5*Math.log(Reference.where(user_id: user.id, star_most: [4, 5]).count + 1)
      score_timeline   = 0.5*Math.log(Timeline.where(user_id: user.id).pluck(:score).reduce(0, :+) + 1)
      score            = 4.0/(1.0/(1+score_comments)+1.0/(1+score_summaries)+1.0/(1+score_references)+1.0/(1+score_timeline))
      User.update(user.id, score: score)
    end
  end

  def update_score_timelines
    Timeline.select(:id, :slug, :nb_contributors, :nb_references, :nb_summaries, :nb_comments, :staging).find_each do |timeline|
      ago             = Time.now - 7.days
      nb_references   = Reference.where(timeline_id: timeline.id, created_at: ago..Time.now).where.not(title_fr: "").count
      nb_comments     = Comment.where(timeline_id: timeline.id, public: true, created_at: ago..Time.now).count
      nb_summaries    = Summary.where(timeline_id: timeline.id, public: true, created_at: ago..Time.now).count
      nb_contributors = TimelineContributor.where(timeline_id: timeline.id, created_at: ago..Time.now).count
      score           = timeline.compute_score(timeline.nb_contributors, timeline.nb_references, timeline.nb_comments, timeline.nb_summaries)*( timeline.staging ? 0.1 : 1 )
      recent_score    = timeline.compute_score(nb_contributors, nb_references, nb_comments,nb_summaries )*( timeline.staging ? 0.1 : 1 )
      Timeline.update(timeline.id, score_recent: recent_score, score: score)
    end
  end

  def compute_occurencies
    tableau_references = Hash.new(0)
    tableau_timelines = Hash.new(0)

    TagPair.delete_all

    # consultation des bases de données et calculs

    #références
    ReferenceTagging.all.group_by { |t| t.reference_id }.map do |reference_id, reference_taggins|
      tag_ids = reference_taggins.map{ |u| u.tag_id }
      tag_ids.each do |tag_id|
        tableau_references[[tag_id, tag_id]] = tableau_references[[tag_id, tag_id]] + 1
      end
      tag_ids.combination(2).to_a.each do |pair|
        tableau_references[pair] = tableau_references[pair]+1
      end
    end

    #controverses
    Tagging.all.group_by { |t| t.timeline_id }.map do |timeline_id, timeline_taggins|
      tag_ids = timeline_taggins.map{ |u| u.tag_id }
      tag_ids.each do |tag_id|
        tableau_timelines[[tag_id, tag_id]] = tableau_timelines[[tag_id, tag_id]] + 1
      end
      tag_ids.combination(2).to_a.each do |pair|
        tableau_timelines[pair] = tableau_timelines[pair]+1
      end
    end

    # insertion des données

    tag_pairs = []
    #références
    Tag.all.pluck(:id).each do |i|
      Tag.all.pluck(:id).select{|item| i <= item}.each do |j|
          tag_pairs << TagPair.new(tag_theme_source: i, tag_theme_target: j, references: true, occurencies: tableau_references[[i,j]]) #en i les sources, en j les cibles
      end
    end

    #controverses
    Tag.all.pluck(:id).each do |i|
      Tag.all.pluck(:id).select{|item| i <= item}.each do |j|
        tag_pairs << TagPair.new(tag_theme_source: i, tag_theme_target: j, references: false, occurencies: tableau_timelines[[i,j]]) #en i les sources, en j les cibles
      end
    end

    TagPair.import tag_pairs
  end

end
