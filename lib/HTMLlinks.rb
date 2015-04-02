class HTMLlinks < Redcarpet::Render::HTML
  attr_accessor :links
  attr_accessor :ref_url
  def link(link, title, content)
    if link !~ /\D/ && !link.empty? && link != "0"
      self.links.push(link.to_i)
      "<a href=\"#{self.ref_url+link}\" class=\"linked-ref\" data-ref=\"#{link}\"> #{content}</a>"
    elsif link[0..6] == "http://"
      "<a href=\"#{link}\"> #{content}</a>"
    else
      content
    end
  end
end
