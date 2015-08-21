module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "ControverSciences"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def tags_hash
    {"archeology"   => I18n.t('helpers.tags_hash_0'),
     "biology"      => I18n.t('helpers.tags_hash_1'),
     "chemistry"    => I18n.t('helpers.tags_hash_2'),
     "planet"       => I18n.t('helpers.tags_hash_3'),
     "epistemology" => I18n.t('helpers.tags_hash_4'),
     "geography"    => I18n.t('helpers.tags_hash_5'),
     "geology"      => I18n.t('helpers.tags_hash_6'),
     "history"      => I18n.t('helpers.tags_hash_7'),
     "informatics"  => I18n.t('helpers.tags_hash_8'),
     "linguistic"   => I18n.t('helpers.tags_hash_9'),
     "pie"          => I18n.t('helpers.tags_hash_10'),
     "medicine"     => I18n.t('helpers.tags_hash_11'),
     "physics"      => I18n.t('helpers.tags_hash_12'),
     "psycho"       => I18n.t('helpers.tags_hash_13'),
     "socio"        => I18n.t('helpers.tags_hash_14'),
     "techno"       => I18n.t('helpers.tags_hash_15')
    }
  end

  def category_names
    {0 => I18n.t('views.references.category_0'),
     1 => I18n.t('views.references.category_1'),
     2 => I18n.t('views.references.category_2'),
     3 => I18n.t('views.references.category_3')}
  end

  def category_hash
    {0 => {0 => I18n.t('helpers.category_hash_0_0'),
           1 => I18n.t('helpers.category_hash_0_1'),
           2 => I18n.t('helpers.category_hash_0_2'),
           3 => I18n.t('helpers.category_hash_0_3'),
           4 => I18n.t('helpers.category_hash_0_4'),
           5 => I18n.t('helpers.category_hash_0_5'),
           6 => I18n.t('helpers.category_hash_0_6'),
           7 => I18n.t('helpers.category_hash_0_7')},
     1 => {0 => I18n.t('helpers.category_hash_1_0'),
           3 => I18n.t('helpers.category_hash_1_3'),
           4 => I18n.t('helpers.category_hash_1_4'),
           5 => I18n.t('helpers.category_hash_1_5'),
           6 => I18n.t('helpers.category_hash_1_6'),
           7 => I18n.t('helpers.category_hash_1_7')},
     2 => {0 => I18n.t('helpers.category_hash_2_0'),
           1 => I18n.t('helpers.category_hash_2_1'),
           2 => I18n.t('helpers.category_hash_2_2'),
           3 => I18n.t('helpers.category_hash_2_3'),
           4 => I18n.t('helpers.category_hash_2_4'),
           5 => I18n.t('helpers.category_hash_2_5'),
           6 => I18n.t('helpers.category_hash_2_6'),
           7 => I18n.t('helpers.category_hash_2_7')},
     3 => {0 => I18n.t('helpers.category_hash_3_0'),
           1 => I18n.t('helpers.category_hash_3_1'),
           3 => I18n.t('helpers.category_hash_3_3'),
           4 => I18n.t('helpers.category_hash_3_4'),
           5 => I18n.t('helpers.category_hash_3_5'),
           6 => I18n.t('helpers.category_hash_3_6'),
           7 => I18n.t('helpers.category_hash_3_7')}
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
           7 => 1000}
    }
  end

  def category_explanation
    {0 => {0 => I18n.t('helpers.category_explanation_0_0'),
           1 => I18n.t('helpers.category_explanation_0_1'),
           2 => I18n.t('helpers.category_explanation_0_2'),
           3 => I18n.t('helpers.category_explanation_0_3'),
           4 => I18n.t('helpers.category_explanation_0_4'),
           5 => I18n.t('helpers.category_explanation_0_5')},
     1 => {0 => I18n.t('helpers.category_explanation_1_0'),
           3 => I18n.t('helpers.category_explanation_1_3'),
           4 => I18n.t('helpers.category_explanation_1_4'),
           5 => I18n.t('helpers.category_explanation_1_5')},
     2 => {0 => I18n.t('helpers.category_explanation_2_0'),
           1 => I18n.t('helpers.category_explanation_2_1'),
           2 => I18n.t('helpers.category_explanation_2_2'),
           3 => I18n.t('helpers.category_explanation_2_3'),
           4 => I18n.t('helpers.category_explanation_2_4'),
           5 => I18n.t('helpers.category_explanation_2_5')},
     3 => {0 => I18n.t('helpers.category_explanation_3_0'),
           1 => I18n.t('helpers.category_explanation_3_1'),
           3 => I18n.t('helpers.category_explanation_3_3'),
           4 => I18n.t('helpers.category_explanation_3_4'),
           5 => I18n.t('helpers.category_explanation_3_5')}
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

  def edges_category
    [[1, I18n.t('helpers.edges_category_1')],
     [2, I18n.t('helpers.edges_category_2')],
     [3, I18n.t('helpers.edges_category_3')],
     [4, I18n.t('helpers.edges_category_4')],
     [5, I18n.t('helpers.edges_category_5')],
     [6, I18n.t('helpers.edges_category_6')],
     [7, I18n.t('helpers.edges_category_7')],
     [8, I18n.t('helpers.edges_category_8')]]
  end

  def forward_edges_category
    edges_category.to_h
  end

  def backward_edges_category
    edges_category.each_with_object({}) do |v, h|
      if v[0].odd?
        h[v[0]+1]=v[1]
      else
        h[v[0]-1]=v[1]
      end
    end
  end

  def binary_value_explanation(binary, value)
    text = I18n.t('helpers.binary_value_text')
    case value
      when 1
        return text + I18n.t('helpers.binary_value_1') + binary.split('&&')[0].downcase + "."
      when 2
        return text + I18n.t('helpers.binary_value_2') + binary.split('&&')[0].downcase + "."
      when 3
        return text + I18n.t('helpers.binary_value_3')
      when 4
        return text + I18n.t('helpers.binary_value_4') + binary.split('&&')[1].downcase + "."
      when 5
        return text + I18n.t('helpers.binary_value_5') + binary.split('&&')[1].downcase + "."
      else
        return ""
    end
  end

  def user_name(user_id)
    User.select(:name).find(user_id).name
  end
end
