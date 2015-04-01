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

  def fields_hash
    {0 => "Introduction",
     1 => "Expérience", 2 => "Résultats", 3 => "Limites de l'étude",
     4 => "Ce que cette étude apporte au débat", 5 => "Remarque(s)",
     6 => "Titre", 7 => "Figure"}
  end

  def fields_plural_hash
    {0 => "les introductions",
     1 => "les résumés de l'expérience", 2 => "les résumés des résultats", 3 => "les résumés des limites de l'étude",
     4 => "Ce que cette étude apporte au débat", 5 => "les remarques",
     6 => "les titres", 7 => "les figures"}
  end

  def fields_singular_hash
    {0 => "l'introduction",
     1 => "le résumé de l'expérience", 2 => "le résumé des résultats", 3 => "le résumé des limites de l'étude",
     4 => "ce que cette étude apporte au débat", 5 => "les remarques",
     6 => "le titre", 7 => "la figure"}
  end

  def explains_hash
    {0 => "cette introduction",
     1 => "ce résumé de l'expérience", 2 => "ce résumé des résultats", 3 => "à ce résumé des limites de l'étude",
     4 => "cette contribution", 5 => "cette remarque",
     6 => "ce titre", 7 => "cette figure"}
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
