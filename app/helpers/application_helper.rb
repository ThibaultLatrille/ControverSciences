module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "ControverSciences"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title} "
    end
  end

  def tags_hash
    {"biology" => "Biologie",
     "immunity" => "Virus et pathogénes", "medicine" => "Médecine et santé",
     "pharmacy" => "Médicaments", "animal" => "Biologie animale", "plant" => "Biologie Végétale",
     "planet" => "Environement", "energy" => "Energies renouvellables",
     "rig" => "Energies fossiles", "archeology" => "Archéologie",
     "space" => "Espace", "physics" => "Physique", "chemistry" => "Chimie",
     "economy" => "Economie et Finance", "social" => "Sciences sociales",
     "pie" => "Mathématiques"}
  end

  def fields_hash
    {1 => "L'éxperience", 2 => "Les résultats", 3 => "Les limites",
     4 => "Quel rapport", 5 => "Remarques" }
  end
end
