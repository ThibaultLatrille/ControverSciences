module ApplicationHelper

  def author
    out = "\nNom\t1er auteur\tContributions"
    User.find(79).timelines.each do |private_timeline|
      out += "\n" + private_timeline.name.html_safe
      authors = {}
      private_timeline.references.each do |ref|
        if ref.best_comment&.user_id
          unless authors.include?(ref.best_comment.user_id)
            authors[ref.best_comment.user_id] =  {"editors" => 0, "contributors" => 0, "name" => User.find(ref.best_comment.user_id).name}
          end
          authors[ref.best_comment.user_id]["editors"] += 1
          ref.best_comment.contributors.each do |c|
            unless authors.include?(c.user_id)
              authors[c.user_id] =  {"editors" => 0, "contributors" => 0, "name" => c.user.name}
            end
            authors[c.user_id]["contributors"] += 1
          end
        end
      end
      out += "\nNom\t1er auteur\tContributions"
      authors.each do |k, dico|
        print(dico)
        out += "\n" + dico["name"].to_s + "\t" + dico["editors"].to_s + "\t" + dico["contributors"].to_s
      end
    end
    print(out)
  end

  def random_choices_and_favorite
    @choices = Timeline.includes(:tags).select(:slug, :id, :name).limit(5).order("RANDOM()")
    if logged_in?
      @favorite = Timeline.find_by(favorite: true, staging: true)
    else
      @choices = @choices.where(staging: false)
      @favorite = Timeline.find_by(favorite: true, staging: false)
    end
  end

  def timelines_connected_to(timeline_id)
    Timeline.joins(:edges)
        .where(edges: {target: timeline_id}).pluck(:name, :id) +
        Timeline.joins('INNER JOIN "edges" ON "edges"."target" = "timelines"."id"')
            .where(edges: {timeline_id: timeline_id}).pluck(:name, :id)
  end

  def full_title(page_title = '')
    base_title = "ControverSciences"
    if page_title.empty?
      base_title
    else
      page_title
    end
  end

  def tags_hash
    {"archeology" => I18n.t('helpers.tags_hash_0'),
     "biology" => I18n.t('helpers.tags_hash_1'),
     "chemistry" => I18n.t('helpers.tags_hash_2'),
     "planet" => I18n.t('helpers.tags_hash_3'),
     "epistemology" => I18n.t('helpers.tags_hash_4'),
     "geography" => I18n.t('helpers.tags_hash_5'),
     "geology" => I18n.t('helpers.tags_hash_6'),
     "history" => I18n.t('helpers.tags_hash_7'),
     "informatics" => I18n.t('helpers.tags_hash_8'),
     "linguistic" => I18n.t('helpers.tags_hash_9'),
     "pie" => I18n.t('helpers.tags_hash_10'),
     "medicine" => I18n.t('helpers.tags_hash_11'),
     "physics" => I18n.t('helpers.tags_hash_12'),
     "psycho" => I18n.t('helpers.tags_hash_13'),
     "socio" => I18n.t('helpers.tags_hash_14'),
     "techno" => I18n.t('helpers.tags_hash_15')
    }
  end

  def category_names
    {0 => I18n.t('views.references.category_0'),
     1 => I18n.t('views.references.category_1'),
     2 => I18n.t('views.references.category_2'),
     3 => I18n.t('views.references.category_3'),
     4 => I18n.t('views.references.category_4'),
     5 => I18n.t('views.references.category_5')}
  end

  def category_source
    {0 => I18n.t('views.references.category_source_journal'),
     1 => I18n.t('views.references.category_source_journal'),
     2 => I18n.t('views.references.category_source_journal'),
     3 => I18n.t('views.references.category_source_book'),
     4 => I18n.t('views.references.category_source_univ'),
     5 => I18n.t('views.references.category_source_journal')}
  end

  def category_unique_id
    {0 => I18n.t('views.references.category_doi'),
     1 => I18n.t('views.references.category_doi'),
     2 => I18n.t('views.references.category_doi'),
     3 => I18n.t('views.references.category_issn'),
     4 => I18n.t('views.references.category_issn'),
     5 => I18n.t('views.references.category_doi')}
  end

  def category_hash
    {0 => {0 => I18n.t('helpers.category_hash_article_0'),
           1 => I18n.t('helpers.category_hash_article_1'),
           2 => I18n.t('helpers.category_hash_article_2'),
           3 => I18n.t('helpers.category_hash_article_3'),
           4 => I18n.t('helpers.category_hash_article_4'),
           5 => I18n.t('helpers.category_hash_article_5'),
           6 => I18n.t('helpers.category_hash_article_6'),
           7 => I18n.t('helpers.category_hash_article_7')},
     1 => {0 => I18n.t('helpers.category_hash_review_0'),
           3 => I18n.t('helpers.category_hash_review_3'),
           4 => I18n.t('helpers.category_hash_review_4'),
           5 => I18n.t('helpers.category_hash_review_5'),
           6 => I18n.t('helpers.category_hash_review_6'),
           7 => I18n.t('helpers.category_hash_review_7')},
     2 => {0 => I18n.t('helpers.category_hash_meta_0'),
           1 => I18n.t('helpers.category_hash_meta_1'),
           2 => I18n.t('helpers.category_hash_meta_2'),
           3 => I18n.t('helpers.category_hash_meta_3'),
           4 => I18n.t('helpers.category_hash_meta_4'),
           5 => I18n.t('helpers.category_hash_meta_5'),
           6 => I18n.t('helpers.category_hash_meta_6'),
           7 => I18n.t('helpers.category_hash_meta_7')},
     3 => {0 => I18n.t('helpers.category_hash_book_0'),
           1 => I18n.t('helpers.category_hash_book_1'),
           3 => I18n.t('helpers.category_hash_book_3'),
           4 => I18n.t('helpers.category_hash_book_4'),
           5 => I18n.t('helpers.category_hash_book_5'),
           6 => I18n.t('helpers.category_hash_book_6'),
           7 => I18n.t('helpers.category_hash_book_7')},
     4 => {0 => I18n.t('helpers.category_hash_phd_0'),
           1 => I18n.t('helpers.category_hash_phd_1'),
           3 => I18n.t('helpers.category_hash_phd_3'),
           4 => I18n.t('helpers.category_hash_phd_4'),
           5 => I18n.t('helpers.category_hash_phd_5'),
           6 => I18n.t('helpers.category_hash_phd_6'),
           7 => I18n.t('helpers.category_hash_phd_7')},
     5 => {0 => I18n.t('helpers.category_hash_letter_0'),
           3 => I18n.t('helpers.category_hash_letter_3'),
           4 => I18n.t('helpers.category_hash_letter_4'),
           5 => I18n.t('helpers.category_hash_letter_5'),
           6 => I18n.t('helpers.category_hash_letter_6'),
           7 => I18n.t('helpers.category_hash_review_7')}
    }
  end

  def category_limit
    {0 => {0 => 1000,
           1 => 1000,
           2 => 1000,
           3 => 1000,
           4 => 1000,
           5 => 1000,
           6 => 180,
           7 => 1000},
     1 => {0 => 4000,
           3 => 1000,
           4 => 1000,
           5 => 1000,
           6 => 180,
           7 => 1000},
     2 => {0 => 1000,
           1 => 1000,
           2 => 1000,
           3 => 1000,
           4 => 1000,
           5 => 1000,
           6 => 180,
           7 => 1000},
     3 => {0 => 1000,
           1 => 4000,
           3 => 1000,
           4 => 1000,
           5 => 1000,
           6 => 180,
           7 => 1000},
     4 => {0 => 1000,
           1 => 4000,
           3 => 1000,
           4 => 1000,
           5 => 1000,
           6 => 180,
           7 => 1000},
     5 => {0 => 4000,
           3 => 1000,
           4 => 1000,
           5 => 1000,
           6 => 180,
           7 => 1000}
    }
  end

  def category_explanation
    {0 => {0 => I18n.t('helpers.category_explanation_intro', category: I18n.t('helpers.article')),
           1 => I18n.t('helpers.category_explanation_experience', category: I18n.t('helpers.article')),
           2 => I18n.t('helpers.category_explanation_results', category: I18n.t('helpers.article')),
           3 => I18n.t('helpers.category_explanation_limits', category: I18n.t('helpers.article')),
           4 => I18n.t('helpers.category_explanation_more', category: I18n.t('helpers.article')),
           5 => I18n.t('helpers.category_explanation_remarque', category: I18n.t('helpers.article'))},
     1 => {0 => I18n.t('helpers.category_explanation_summary', category: I18n.t('helpers.review')),
           3 => I18n.t('helpers.category_explanation_limits', category: I18n.t('helpers.review')),
           4 => I18n.t('helpers.category_explanation_more', category: I18n.t('helpers.review')),
           5 => I18n.t('helpers.category_explanation_remarque', category: I18n.t('helpers.review'))},
     2 => {0 => I18n.t('helpers.category_explanation_intro', category: I18n.t('helpers.meta')),
           1 => I18n.t('helpers.category_explanation_experience', category: I18n.t('helpers.meta')),
           2 => I18n.t('helpers.category_explanation_results', category: I18n.t('helpers.meta')),
           3 => I18n.t('helpers.category_explanation_limits', category: I18n.t('helpers.meta')),
           4 => I18n.t('helpers.category_explanation_more', category: I18n.t('helpers.meta')),
           5 => I18n.t('helpers.category_explanation_remarque', category: I18n.t('helpers.meta'))},
     3 => {0 => I18n.t('helpers.category_explanation_intro', category: I18n.t('helpers.book')),
           1 => I18n.t('helpers.category_explanation_summary', category: I18n.t('helpers.book')),
           3 => I18n.t('helpers.category_explanation_limits', category: I18n.t('helpers.book')),
           4 => I18n.t('helpers.category_explanation_more', category: I18n.t('helpers.book')),
           5 => I18n.t('helpers.category_explanation_remarque', category: I18n.t('helpers.book'))},
     4 => {0 => I18n.t('helpers.category_explanation_intro', category: I18n.t('helpers.phd')),
           1 => I18n.t('helpers.category_explanation_summary', category: I18n.t('helpers.phd')),
           3 => I18n.t('helpers.category_explanation_limits', category: I18n.t('helpers.phd')),
           4 => I18n.t('helpers.category_explanation_more', category: I18n.t('helpers.phd')),
           5 => I18n.t('helpers.category_explanation_remarque', category: I18n.t('helpers.phd'))},
     5 => {0 => I18n.t('helpers.category_explanation_summary', category: I18n.t('helpers.review')),
           3 => I18n.t('helpers.category_explanation_limits', category: I18n.t('helpers.review')),
           4 => I18n.t('helpers.category_explanation_more', category: I18n.t('helpers.review')),
           5 => I18n.t('helpers.category_explanation_remarque', category: I18n.t('helpers.review'))},
    }
  end

  def user_profils
    {1 => I18n.t('helpers.user_profils_1'),
     2 => I18n.t('helpers.user_profils_2'),
     3 => I18n.t('helpers.user_profils_3'),
     4 => I18n.t('helpers.user_profils_4'),
     5 => I18n.t('helpers.user_profils_5'),
     6 => I18n.t('helpers.user_profils_6'),
     7 => I18n.t('helpers.user_profils_7'),
     8 => I18n.t('helpers.user_profils_8'),
     9 => I18n.t('helpers.user_profils_9')}
  end

  def user_profil_info
    [I18n.t('helpers.user_profils_info_1'),
     I18n.t('helpers.user_profils_info_2'),
     I18n.t('helpers.user_profils_info_3'),
     I18n.t('helpers.user_profils_info_4'),
     I18n.t('helpers.user_profils_info_5'),
     I18n.t('helpers.user_profils_info_6'),
     I18n.t('helpers.user_profils_info_7'),
     I18n.t('helpers.user_profils_info_8'),
     I18n.t('helpers.user_profils_info_9')]
  end

  def star_hash
    {1 => I18n.t('helpers.star_hash_1'),
     2 => I18n.t('helpers.star_hash_2'),
     3 => I18n.t('helpers.star_hash_3'),
     4 => I18n.t('helpers.star_hash_4'),
     5 => I18n.t('helpers.star_hash_5')}
  end

  def binary_hash
    {1 => I18n.t('helpers.binary_hash_1'),
     2 => I18n.t('helpers.binary_hash_2'),
     3 => I18n.t('helpers.binary_hash_3'),
     4 => I18n.t('helpers.binary_hash_4'),
     5 => I18n.t('helpers.binary_hash_5')}
  end

  def binary_value_explanation(binary, value)
    if binary.present?
      text = I18n.t('helpers.binary_value_text')
      case value
      when 1
        text + I18n.t('helpers.binary_value_1') + binary.split('&&')[0].downcase + "."
      when 2
        text + I18n.t('helpers.binary_value_2') + binary.split('&&')[0].downcase + "."
      when 3
        text + I18n.t('helpers.binary_value_3')
      when 4
        text + I18n.t('helpers.binary_value_4') + binary.split('&&')[1].downcase + "."
      when 5
        text + I18n.t('helpers.binary_value_5') + binary.split('&&')[1].downcase + "."
      else
        ''
      end
    end
  end

  def user_name(user_id)
    User.select(:name).find(user_id).name
  end

  def can_edit_private_timeline(frame, user_id)
    PrivateTimeline.find_by(user_id: user_id, timeline_id: frame.timeline_id) && frame.timeline.staging
  end
end
