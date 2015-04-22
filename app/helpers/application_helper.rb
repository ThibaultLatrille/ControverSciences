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
     "ethics" => "Ethique",
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

  def review_hash
    {0 => "Résumé de la review",
     3 => "Limites de la review",
     4 => "Ce que cette review apporte au débat", 5 => "Remarque(s) sur la review",
     6 => "Titre de la review", 7 => "Figure"}
  end

  def star_hash
    { 1 => "Cette référence n'a rien à faire là et est inintéressante.",
      2 => "Cette référence est intéressante mais n'apporte rien.",
      3 => "Cette référence est scientifiquement peu solide.",
      4 => "Cette référence est intéressante et rigoureuse.",
      5 => "Cette référence est à lire absolument !"}
  end

  def binary_hash
    { 1 => "très fermement",
      2 => "modérément",
      3 => "cette référence est neutre.",
      4 => "modérément",
      5 => "très fermement" }
  end

  def user_name( user_id )
    User.select( :name ).find( user_id ).name
  end
end
