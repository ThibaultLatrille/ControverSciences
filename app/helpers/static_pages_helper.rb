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

  def meta_description(meta_descri)
    if meta_descri.blank?
      "Portail de vulgarisation scientique destiné à éclairer débats et controverses.
      Animé par des scientifiques, pour tout public"
    else
      ActionView::Base.full_sanitizer.sanitize meta_descri
    end
  end

  def meta_keywords
    "controverse scientifique débat discussion interpretation polémique"
  end

  def full_title(page_title)
    if page_title.empty?
      site_name
    else
      ActionView::Base.full_sanitizer.sanitize "#{page_title} | #{site_name}"
    end
  end
end
