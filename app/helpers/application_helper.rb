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
    {"archeology"   => "Archéologie",
     "biology"      => "Biologie",
     "chemistry"    => "Chimie",
     "planet"       => "Ecologie",
     "epistemology" => "Epistémologie",
     "geography"    => "Géographie",
     "geology"      => "Géologie",
     "history"      => "Histoire",
     "informatics"  => "Informatique",
     "linguistic"   => "Linguistique",
     "pie"          => "Mathématiques",
     "medicine"     => "Médecine et santé",
     "physics"      => "Physique",
     "psycho"       => "Psychologie",
     "socio"        => "Sociologie",
     "techno"       => "Technologie"
    }
  end

  def category_names
    {0 => "Article",
     1 => "Review",
     2 => "Meta-analyse",
     3 => "Livre"}
  end

  def category_hash
    {0 => {0 => "Introduction à l'article",
           1 => "Expériences de l'article",
           2 => "Résultats de l'article",
           3 => "Limites de l'article",
           4 => "Ce que cet article apporte au débat",
           5 => "Remarque(s) sur l'article",
           6 => "Titre de l'article",
           7 => "Figure"},
     1 => {0 => "Résumé de la review",
           3 => "Limites de la review",
           4 => "Ce que cette review apporte au débat",
           5 => "Remarque(s) sur la review",
           6 => "Titre de la review",
           7 => "Figure"},
     2 => {0 => "Introduction à la meta-analyse",
           1 => "Expériences de la meta-analyse",
           2 => "Résultats de la meta-analyse",
           3 => "Limites de la meta-analyse",
           4 => "Ce que cette meta-analyse apporte au débat",
           5 => "Remarque(s) sur la meta-analyse",
           6 => "Titre de la meta-analyse",
           7 => "Figure"},
     3 => {0 => "Introduction au livre",
           1 => "Résumé et résultats du livre",
           3 => "Limites du livre",
           4 => "Ce que ce livre apporte au débat",
           5 => "Remarque(s) sur le livre",
           6 => "Titre du Livre",
           7 => "Figure"}
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
    {0 => {0 => "L'introduction permet au lecteur de situer cet article dans
                              la controverse et d'amorcer en douceur l’expérience et les résultats de l'étude.",
           1 => "Résumé de l'expérience (ou des expériences) réalisé dans cette étude.",
           2 => "Résumé du résultat (ou des résultats) de l’expérience (ou des expériences)",
           3 => "Un résumé des limites de l’étude, que ce soit méthodologique, conceptuelle ou
                          philosophique. Toute étude à ses limites.",
           4 => "Ce que cette étude apporte de plus et comment elle permet d'éclairer
                          la controverse.",
           5 => "Toutes les remarques qui ne rentrent pas dans les champs précédents.
                          Cela peut être sur les affiliations ou les financements douteux de l'étude.
                          Une anecdote sur ce papier ou ces auteurs, ou simplement une remarque totalement
                          subjective."},
     1 => {0 => "Le résumé de la review permet au lecteur de
                  comprendre cette étude dans le cadre de cette controverse.",
           3 => "Un résumé des limites de la review, que ce soit méthodologique, conceptuelle ou
                          philosophique. Toute étude à ses limites.",
           4 => "Ce que cette review apporte de plus et comment elle permet d'éclairer
                          la controverse.",
           5 => "Toutes les remarques qui ne rentrent pas dans les champs précédents.
                          Cela peut être sur les affiliations ou les financements douteux de la review.
                          Une anecdote sur ce papier ou ces auteurs, ou simplement une remarque totalement
                          subjective."},
     2 => {0 => "L'introduction permet au lecteur de situer cette meta-analyse dans
                              la controverse et d'amorcer en douceur l’expérience et les résultats de l'étude.",
           1 => "Résumé de l'expérience (ou des expériences) réalisé dans cette meta-analyse.",
           2 => "Résumé du résultat (ou des résultats) de l’expérience (ou des expériences).",
           3 => "Un résumé des limites de la meta-analyse, que ce soit méthodologique, conceptuelle ou
                          philosophique. Toute étude à ses limites.",
           4 => "Ce que cette meta-analyse apporte de plus et comment elle permet d'éclairer
                          la controverse.",
           5 => "Toutes les remarques qui ne rentrent pas dans les champs précédents.
                          Cela peut être sur les affiliations ou les financements douteux de la meta-analyse .
                          Une anecdote sur ce papier ou ces auteurs, ou simplement une remarque totalement
                          subjective."},
     3 => {0 => "L'introduction permet au lecteur de situer ce livre dans
                              la controverse et d'amorcer en douceur les résultats du livre.",
           1 => "Le résumé et les résultats du livre permet au lecteur de
                  comprendre cette étude dans le cadre de cette controverse.",
           3 => "Un résumé des limites du livre, que ce soit méthodologique, conceptuelle ou
                          philosophique. Toute étude à ses limites.",
           4 => "Ce que ce livre apporte de plus et comment il permet d'éclairer
                          la controverse.",
           5 => "Toutes les remarques qui ne rentrent pas dans les champs précédents.
                          Cela peut être sur les affiliations ou les financements douteux du livre.
                          Une anecdote sur ce papier ou ces auteurs, ou simplement une remarque totalement
                          subjective."}
    }
  end

  def user_profils
    {1 => "Dilemnatique",
     2 => "Reformulateur",
     3 => "Ecrivain",
     4 => "Encyclopédiste",
     5 => "Analyste",
     6 => "Passionné",
     7 => "Adulé",
     8 => "Fanatique",
     9 => "Bienveillant"}
  end

  def user_profil_info
    ["A créé des controverses qui sont bien classées.",
     "A écrit des propositions de formulation qui sont bien classées.",
     "A écrit des synthèses qui sont bien classées",
     "A ajouté des références qui sont bien classées.",
     "A ajouté des analyses qui sont bien classées.",
     "S'intéresse à des thèmes variés.",
     "A reçu des crédits par les autres contributeurs.",
     "A donné des crédits aux autres contributeurs.",
     "A corrigé des fautes d'orthographes."]
  end

  def star_hash
    {1 => "Cette référence est peu rigoureuse et n'est pas importante pour comprendre la controverse.",
     2 => "Cette référence est rigoureuse mais pas importante pour comprendre la controverse.",
     3 => "Cette référence est peu rigoureuse mais est importante pour comprendre la controverse.",
     4 => "Cette référence est rigoureuse et est importante pour comprendre la controverse.",
     5 => "Cette référence est à lire absolument dans le cadre de cette controverse !"}
  end

  def binary_hash
    {1 => "très fermement",
     2 => "modérément",
     3 => "cette référence est neutre.",
     4 => "modérément",
     5 => "très fermement"}
  end

  def edges_category
    [[1, "À une lettre de réponse"],
     [2, "Est une lettre de réponse à"],
     [3, "Précise"],
     [4, "Est précisée par"],
     [5, "Infirme"],
     [6, "Est infirmée par"],
     [7, "Confirme"],
     [8, "Est confirmée par"]]
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
    text = "Cette référence est "
    case value
      when 1
        return text + "très fermement du coté " + binary.split('&&')[0].downcase + "."
      when 2
        return text + "du coté " + binary.split('&&')[0].downcase + "."
      when 3
        return text + "neutre."
      when 4
        return text + "du coté " + binary.split('&&')[1].downcase + "."
      when 5
        return text + "très fermement du coté " + binary.split('&&')[1].downcase + "."
      else
        return ""
    end
  end

  def user_name(user_id)
    User.select(:name).find(user_id).name
  end
end
