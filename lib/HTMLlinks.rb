class HTMLlinks < Redcarpet::Render::HTML
  attr_accessor :links
  attr_accessor :ref_url
  def link(link, title, content)
    if link !~ /\D/ && !link.blank? && link != "0"
      self.links.push(link.to_i)
      "<a href=\"#{self.ref_url+link}\" class=\"linked-ref\" data-ref=\"#{link}\">#{content}</a>"
    elsif (link[0..6] == "http://") || (link[0..7] == "https://")
      "<a href=\"#{link}\">#{content}</a>"
    else
      content
    end
  end
end

class RenderWithoutWrap < Redcarpet::Render::HTML
  def postprocess(full_document)
    Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(full_document)[1] rescue full_document
  end
end
