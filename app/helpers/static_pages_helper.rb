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
      "ControverSciences est un portail collaboratif et indépendant qui rassemble les publications scientifiques autour de questions controversées, en les rendant accessible à tous."
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
      ActionView::Base.full_sanitizer.sanitize page_title
    end
  end
end
