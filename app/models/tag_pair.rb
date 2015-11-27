class TagPair < ActiveRecord::Base

  def compute_occurencies_references_and_timelines
    tableau_references = Hash.new(0)
    tableau_timelines = Hash.new(0)

    TagPair.destroy_all

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

    #références
    for i in 1..Tag.all.length
      for j in i..Tag.all.length
        TagPair.create(tag_theme_source: i, tag_theme_target: j, references:TRUE, occurencies: tableau_references[[i,j]]) #en i les sources, en j les cibles
      end
    end

    #controverses
    for i in 1..Tag.all.length
      for j in i..Tag.all.length
        TagPair.create(tag_theme_source: i, tag_theme_target: j, references: FALSE, occurencies: tableau_timelines[[i,j]]) #en i les sources, en j les cibles
      end
    end

  end


end
