class HTMLlinks < Redcarpet::Render::HTML
  attr_accessor :links
  def link(link, title, content)
    if link !~ /\D/ && !link.empty? && link != "0"
      self.links << link.to_i
      "<a href=\"http://0.0.0.0:3000/references/#{link[1..-2]}\"> #{content}</a>"
    else
      "<a href=\"#{link}\"> #{content}</a>"
    end
  end
end
