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

  def star_hash
    { 1 => "Elle rape un peu les fesses quand on se torche avec",
      2 => "Référence très interessante mais, aucun rapport avec la choucroute",
      3 => "Ils se sont quand même pas foulés trois neurones pour le pondre",
      4 => "Des bons petits gars et du bon boulot",
      5 => "J'ai eu un orgasme cérébrale en le lisant"}
  end

  def list_mails
    %w(cnrs irstea ifsttar ined inria inra inserm ird crasc ens ecp ec-lyon.fr ec-lille.fr
    ec-nantes.fr insa ifremer brgm onf andra cea cemagref ineris irsn cnes cirad universcience
    mnhn.fr ehess.fr sorbonne.fr ensam.fr enssib.fr jussieu.fr sciences-po.fr obspm.fr palais-decouverte.fr
    ecp.fr inalco.fr dauphine.fr cnam.fr college-de-france.fr unistra.fr uha.fr u-bordeaux1.fr u-bordeaux3.fr
    u-bordeaux4.fr u-bordeaux2.fr univ-pau.fr lacc.univ-bpclermont.fr u-clermont1.fr univ-rennes1.fr
    univ-rennes2.fr univ-brest.fr univ-ubs.fr univ-orleans.fr univ-tours.fr univ-reims.fr univ-corse.fr
    fcomte.fr univ-paris1.fr u-paris2.fr univ-paris3.fr paris-sorbonne.fr univ-paris5.fr upmc.fr
    univ-paris-diderot.fr icp.fr univ-paris8.fr u-paris10.fr u-pec.fr univ-paris13.fr univ-mlv.fr u-cergy.fr
    uvsq.fr univ-evry.fr u-psud.fr univ-montp1.fr univ-montp2.fr univ-montp3.fr unimes.fr univ-perp.fr im.fr
    univ-metz.fr uhp-nancy.fr univ-nancy2.fr univ-tlse1.fr univ-tlse2.fr ups-tlse.fr ict-toulouse.asso.fr
    univ-jfc.fr univ-artois.fr univ-lille1.fr univ-lille2.fr univ-lille3.fr univ-catholille.fr univ-littoral.fr
    valenciennes.fr unicaen.fr univ-lehavre.fr univ-rouen.fr univ-angers.fr uco.fr univ-lemans.fr univ-nantes.fr
    u-picardie.fr utc univ-larochelle.fr univ-poitiers.fr univ-provence.fr univmed.fr univ-cezanne.fr
    univ-avignon.fr unice.fr univ-tln.fr univ-savoie.fr ujf-grenoble.fr upmf-grenoble.fr u-grenoble3.fr
    univ-lyon1.fr univ-lyon2.fr univ-lyon3.fr univ-catholyon.fr univ-st-etienne.fr univ-ag.fr
    univ-reunion ufp.pf unvi-nc.nc)
  end
end
