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

  def tags_list
    [["planet","Environement"],["biology","Biologie"],["immunity","Immunité et santé"],
     ["pharmacy","Médicaments"],["animal","Animaux"],["plant","Végétaux"],
     ["space","Espace"],["physics","Physique"],["chemistry","Chimie"],
     ["economy","Economie et Finance"],["social","Sciences sociales"],
     ["pie","Mathématiques"]]
  end
end
