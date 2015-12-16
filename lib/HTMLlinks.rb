class Redcarpet::Render::HTML
  def superscript(text)
    if text[0] == "_"
      "<sub>[#{text[1..-1]}]</sub>"
    else
      "<sup>[#{text}]</sup>"
    end
  end
end

class HTMLlinks < Redcarpet::Render::HTML
  attr_accessor :links
  attr_accessor :counter
  attr_accessor :root_url
  def link(link, title, content)
    if link !~ /\D/ && !link.blank? && link != "0"
      if content == "*"
        if self.links[link.to_i]
          count = self.links[link.to_i]
        else
          count = self.counter
          self.counter += 1
          self.links[link.to_i] = count
        end
        "<a href=\"#{self.root_url + "/references/" + link}\" class=\"linked-ref\" data-ref=\"#{link}\" target=\"_blank\"><sup>[#{count}]</sup></a>"
      else
        unless self.links[link.to_i]
          self.links[link.to_i] = false
        end
        "<a href=\"#{self.root_url + "/references/" + link}\" class=\"linked-ref\" data-ref=\"#{link}\" target=\"_blank\">#{content}</a>"
      end
    elsif (link[0..6] == "http://") || (link[0..7] == "https://")
      "<a href=\"#{link}\" target=\"_blank\">#{content}</a>"
    elsif link[0..10] == "/timelines/"
      "<a href=\"#{self.root_url + link }\" target=\"_blank\">#{content}</a>"
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

class String
  def length_sub
    self.gsub("\r\n"," ").length
  end
end
