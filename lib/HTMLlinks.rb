class Redcarpet::Render::HTML
  def superscript(text)
    if text[0] == "_"
      "<sub>#{text[1..-1]}</sub>"
    else
      "<sup>#{text}</sup>"
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
    elsif link[0..10] == "/timelines/" || link[0..13] == "/controverses/"
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
    self.gsub(/\[\*\]\([0-9]*\)/, '')
        .gsub(/\]\(\/timelines\/[0-9]*\)/, '')
        .gsub(/\]\((?:(?:https?|\(ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9]+-?)*[a-z0-9]+)(?:\.(?:[a-z0-9]+-?)*[a-z0-9]+)*(?:\.(?:[a-z]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\)/, '')
        .gsub(/\*|\^|_|\(|\)|\[|\]|-/, '')
        .gsub(/[0-9]\. /, '')
        .gsub("\r\n", " ").length
  end
end
