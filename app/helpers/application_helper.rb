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
    {"archeology" => "Archéologie",
     "biology" => "Biologie",
     "chemistry" => "Chimie",
     "planet" => "Ecologie",
     "epistemology" => "Epistémologie",
     "geography" => "Géographie",
     "geology" => "Géologie",
     "history" => "Histoire",
     "informatics" => "Informatique",
     "linguistic" => "Linguistique",
     "pie" => "Mathématiques",
     "medicine" => "Médecine et santé",
     "physics" => "Physique",
     "psycho" => "Psychologie",
     "socio" => "Sociologie",
     "techno" => "Technologie"
     }
  end

  def article_hash
    {0 => "Introduction à l'article",
     1 => "Expériences de l'article", 2 => "Résultats de l'article", 3 => "Limites de l'article",
     4 => "Ce que cet article apporte au débat", 5 => "Remarque(s) sur l'article",
     6 => "Titre de l'article", 7 => "Figure"}
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

  def review_hash
    {0 => "Résumé de la review",
     3 => "Limites de la review",
     4 => "Ce que cette review apporte au débat", 5 => "Remarque(s) sur la review",
     6 => "Titre de la review", 7 => "Figure"}
  end

  def star_hash
    { 1 => "Cette référence n'est pas du tout rigoureuse et n'apporte rien à la controverse.",
      2 => "Cette référence est rigoureuse mais n'apporte rien à la controverse.",
      3 => "Cette référence est peu rigoureuse mais est importante pour comprendre la controverse.",
      4 => "Cette référence est rigoureuse et est importante pour comprendre la controverse.",
      5 => "Cette référence est à lire absolument dans le cadre de cette controverse !"}
  end

  def binary_hash
    { 1 => "très fermement",
      2 => "modérément",
      3 => "cette référence est neutre.",
      4 => "modérément",
      5 => "très fermement" }
  end

  def edges_category
    [[1, "A une lettre de réponse :"],
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
    edges_category.each_with_object({}) do |v,h|
      if v[0].odd?
        h[v[0]+1]=v[1]
      else
        h[v[0]-1]=v[1]
      end
    end
  end

  def binary_value_explanation( binary, value )
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

  def user_name( user_id )
    User.select( :name ).find( user_id ).name
  end
end
