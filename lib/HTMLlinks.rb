class HTMLlinks < Redcarpet::Render::HTML
  def link(link, title, content)
    if link[0] == '-' && link[-1] == '-'
      "<a href=\"http://0.0.0.0:3000/references/#{link[1..-2]}\"> #{content}</a>"
      self.links << link[1..-2]
    else
      "<a href=\"#{link}\"> #{content}</a>"
    end
  end
end