module StaticPagesHelper

  def site_name
    "ControverSciences"
  end

  def site_url
    if Rails.env.production?
      "https://controversciences.org"
    else
      "http://127.0.0.1:3000"
    end
  end

  def meta_author
    "Thibault Latrille"
  end

  def meta_description(meta_descri)
    if meta_descri.blank?
      t('helpers.meta_description')
    else
      ActionView::Base.full_sanitizer.sanitize meta_descri
    end
  end

  def meta_keywords
    t('helpers.meta_keywords')
  end

  def full_title(page_title)
    if page_title.empty?
      site_name
    else
      ActionView::Base.full_sanitizer.sanitize page_title
    end
  end
end
