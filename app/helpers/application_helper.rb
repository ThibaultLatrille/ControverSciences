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
    {"biology" => "Biologie",
     "immunity" => "Virus et pathogènes", "medicine" => "Médecine et santé",
     "pharmacy" => "Médicaments", "neuro" => "Neuro & psycho", "animal" => "Biologie animale",
     "plant" => "Biologie Végétale",
     "planet" => "environnement", "energy" => "Energies renouvellables",
     "rig" => "Energies fossiles", "archeology" => "Archéologie",
     "space" => "Espace", "physics" => "Physique", "chemistry" => "Chimie",
     "social" => "Sciences sociales",
     "pie" => "Mathématiques"}
  end

  def fields_hash
    {0 => "Introduction",
     1 => "Expérience", 2 => "Résultats", 3 => "Limites de l'étude",
     4 => "Ce que cette étude apporte au débat", 5 => "Remarque(s)" }
  end

  def star_hash
    { 1 => "Cette référence n'a rien à faire là et est inintéressante.",
      2 => "Cette référence est intéressante mais n'apporte rien.",
      3 => "Cette référence est scientifiquement peu solide.",
      4 => "Cette référence est intéressante et rigoureuse.",
      5 => "A lire absolument !"}
  end

  def binary_hash
    { 1 => "Un peu.",
      2 => "Beaucoup.",
      3 => "Passionement.",
      4 => "A la folie.",
      5 => "Pas du tout" }
  end
end
