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
     "immunity" => "Virus et pathogénes", "medicine" => "Médecine et santé",
     "pharmacy" => "Médicaments", "neuro" => "Neuro & psycho", "animal" => "Biologie animale",
     "plant" => "Biologie Végétale",
     "planet" => "Environement", "energy" => "Energies renouvellables",
     "rig" => "Energies fossiles", "archeology" => "Archéologie",
     "space" => "Espace", "physics" => "Physique", "chemistry" => "Chimie",
     "social" => "Sciences sociales",
     "pie" => "Mathématiques"}
  end

  def fields_hash
    {1 => "L'éxperience", 2 => "Les résultats", 3 => "Les limites",
     4 => "Quel rapport", 5 => "Remarques" }
  end

  def star_hash
    { 1 => "Elle rape un peu les fesses quand on se torche avec",
      2 => "Référence très interessante mais, aucun rapport avec la choucroute",
      3 => "Ils se sont quand même pas foulés trois neurones pour le pondre",
      4 => "Des bons petits gars et du bon boulot",
      5 => "J'ai eu un orgasme cérébrale en le lisant"}
  end
end
