module MajHelper

  def maj_v_8
    ActiveRecord::Base.transaction do
      Edge.find_each do |edge|
        plus = EdgeVote.where( edge_id: edge.id, value: true).count
        minus = EdgeVote.where( edge_id: edge.id, value: false).count
        edge.plus = plus
        edge.minus = minus
        edge.balance = plus - minus
        edge.save!
        EdgeVote.find_or_create_by( user_id: edge.user_id,
                                    edge_id: edge.id,
                                    value: true )
      end
      ReferenceEdge.find_each do |ref_edge|
        plus = ReferenceEdgeVote.where( reference_edge_id: ref_edge.id, value: true, category: ref_edge.category).count
        minus = ReferenceEdgeVote.where( reference_edge_id: ref_edge.id, value: false, category: ref_edge.category).count
        ref_edge.plus = plus
        ref_edge.minus = minus
        ref_edge.balance = plus - minus
        ref_edge.save!
        ReferenceEdgeVote.find_or_create_by( user_id: ref_edge.user_id,
                                    reference_edge_id: ref_edge.id,
                                    category: ref_edge.category,
                                    timeline_id: ref_edge.timeline_id,
                                    value: true )
      end
    end
  end

  def maj_v_7
    ActiveRecord::Base.transaction do
      Credit.destroy_all
      Summary.update_all( balance: 0)
      FrameCredit.destroy_all
      Frame.update_all( balance: 0)
      Vote.destroy_all
      Comment.update_all( f_0_balance: 0, f_1_balance: 0, f_2_balance: 0, f_3_balance: 0, f_4_balance: 0,
                          f_5_balance: 0, f_6_balance: 0, f_7_balance: 0)
      Reference.update_all( nb_votes: 0)
      User.find_each(&:save)
      Reference.find_each(&:save)
      Timeline.find_each(&:save)
    end
  end

  def maj_v_6
    ActiveRecord::Base.transaction do
      SuggestionChildVote.where( value: false).destroy_all
      SuggestionVote.where( value: false).destroy_all
      Timeline.find_each do |tim|
        frame = Frame.find_by(timeline_id: tim.id, best: true)
        tim.set_tag_list( frame.get_tag_list )
        TimelineContributor.where( timeline_id: tim.id).group_by{|t| t.user_id}.map do |user_id, timeline_contributors|
          if timeline_contributors.length > 1
            TimelineContributor.where( timeline_id: tim.id, user_id: user_id).destroy_all
            TimelineContributor.create!( timeline_id: tim.id, user_id: user_id, bool: true)
          end
        end
        tim.update_columns( nb_contributors: TimelineContributor.where( timeline_id: tim.id).count)
      end
      Reference.find_each do |ref|
        ReferenceContributor.where( reference_id: ref.id).group_by{|t| t.user_id}.map do |user_id, reference_contributors|
          if reference_contributors.length > 1
            ReferenceContributor.where( reference_id: ref.id, user_id: user_id).destroy_all
            ReferenceContributor.create!( reference_id: ref.id, user_id: user_id, bool: true)
          end
        end
        ref.update_columns( nb_contributors: ReferenceContributor.where( reference_id: ref.id).count)
      end
      ref = Reference.find(2)
      ref.update_columns( title_fr: Comment.find(2).title_markdown )
      while true
        edge = Edge.where( reversible: true ).first
        reverse = Edge.find_by( timeline_id: edge.target, target: edge.timeline_id )
        if reverse
          reverse.destroy
        end
        edge.update_columns(reversible: false)
        if Edge.where( reversible: true ).count < 1
          break
        end
      end
      EdgeVote.destroy_all
      ReferenceEdge.destroy_all
      ReferenceEdgeVote.destroy_all
      NotificationSuggestion.destroy_all
      Notification.where(category: 7).destroy_all
      User.find_each do |user|
        user.update_columns(nb_notifs: user.notifications_all_important)
      end
    end
  end

  def maj_v_5
    ActiveRecord::Base.transaction do
      Edge.find_each do |edge|
        reverse = Edge.find_by( timeline_id: edge.target, target: edge.timeline_id )
        if reverse
          Edge.where(id: [edge.id, reverse.id]).update_all( reversible: true)
        end
      end
    end
  end

  def maj_v_4
    ActiveRecord::Base.transaction do
      Reference.find_each do |ref|
        ref.save
      end
    end
  end

  def maj_v_3
    ActiveRecord::Base.transaction do
      Timeline.find_each do |timeline|
        frame = Frame.new( user_id: timeline.user_id, best: true, binary: timeline.binary,
                           content: "", name: timeline.name, timeline_id: timeline.id )
        frame.set_tag_list(timeline.get_tag_list)
        frame.save!
      end
      User.find_each do |user|
        user.update_columns( nb_notifs: user.notifications_all_important )
      end
    end
  end

  def maj_v_2
    ActiveRecord::Base.transaction do
      ethic = Tag.find_by(name: "ethics")
      Tagging.where( tag_id: ethic.id ).destroy_all
    end
  end

  def maj_v_1
    ActiveRecord::Base.transaction do
      Like.all.delete_all
      SuggestionVote.all.delete_all
      SuggestionChildVote.all.delete_all
      Timeline.all.update_all(nb_likes: 0)
      Suggestion.all.update_all(plus: 0, minus: 0, balance: 0)
      SuggestionChild.all.update_all(plus: 0, minus: 0, balance: 0)
      Timeline.where(debate: false).each do |tim|
        text = "Discussion libre autour de la controverse : **#{tim.name.strip}**"
        Suggestion.create!(user_id: tim.user_id, timeline_id: tim.id, comment: text)
      end
      Timeline.all.update_all(debate: true)
      Reference.find_each do |ref|
        ref.binary_1 = Binary.where( reference_id: ref.id, value: 1).count
        ref.binary_2 = Binary.where( reference_id: ref.id, value: 2).count
        ref.binary_3 = Binary.where( reference_id: ref.id, value: 3).count
        ref.binary_3 = Binary.where( reference_id: ref.id, value: 3).count
        ref.binary_5 = Binary.where( reference_id: ref.id, value: 5).count
        dico = { 1 => ref.binary_1, 2 => ref.binary_2,
                 3 => ref.binary_3, 4 => ref.binary_4,
                 5 => ref.binary_5}
        most = dico.max_by{ |k,v| v }
        if most[1] > 0
          ref.binary_most = most[0]
        else
          ref.binary_most = 0
        end
        ref.star_1 = Rating.where( reference_id: ref.id, value: 1).count
        ref.star_2 = Rating.where( reference_id: ref.id, value: 2).count
        ref.star_3 = Rating.where( reference_id: ref.id, value: 3).count
        ref.star_3 = Rating.where( reference_id: ref.id, value: 3).count
        ref.star_5 = Rating.where( reference_id: ref.id, value: 5).count
        dico = { 1 => ref.star_1, 2 => ref.star_2,
                 3 => ref.star_3, 4 => ref.star_4,
                 5 => ref.star_5}
        most = dico.max_by{ |k,v| v }
        if most[1] > 0
          ref.star_most = most[0]
        else
          ref.star_most = 0
        end
        ref.save!
      end
      Timeline.find_each do |tim|
        tim.binary_0 = Reference.where( timeline_id: tim.id, binary_most: 0).count
        tim.binary_1 = Reference.where( timeline_id: tim.id, binary_most: 1).count
        tim.binary_2 = Reference.where( timeline_id: tim.id, binary_most: 2).count
        tim.binary_3 = Reference.where( timeline_id: tim.id, binary_most: 3).count
        tim.binary_3 = Reference.where( timeline_id: tim.id, binary_most: 3).count
        tim.binary_5 = Reference.where( timeline_id: tim.id, binary_most: 5).count
        tim.save!
      end
    end
  end
end
