class HTMLlinks < Redcarpet::Render::HTML
  attr_accessor :links
  attr_accessor :ref_url
  def link(link, title, content)
    if link !~ /\D/ && !link.empty? && link != "0"
      self.links << link.to_i
      "<a href=\"#{self.ref_url+link}\"> #{content}</a>"
    else
      "<a href=\"#{link}\"> #{content}</a>"
    end
  end
end
