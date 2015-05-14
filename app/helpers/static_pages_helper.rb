module StaticPagesHelper

  def site_name
    "ControverSciences"
  end

  def site_url
    if Rails.env.production?
      "http://www.controversciences.org"
    else
      "http://localhost:3000"
    end
  end

  def meta_author
    "Thibault Latrille"
  end

  def meta_description
    "Portail de vulgarisation scientique destiné à éclairer débats et controverses.
      Animé par des scientifiques, pour tout public"
  end

  def meta_keywords
    "controverse scientifique débat discussion interpretation polémique"
  end

  def full_title(page_title)
    if page_title.empty?
      site_name
    else
      "#{page_title} | #{site_name}"
    end
  end
end
