#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "ControverSciences"
    xml.author "Thibault Latrille"
    xml.description t('helpers.meta_description')
    xml.link "https://controversciences.org"
    xml.language "fr"

    for timeline in @timeline_feed
      xml.item do
        xml.title timeline.name
        xml.author timeline.user.name
        xml.pubDate timeline.updated_at.to_s(:rfc822)
        xml.link timeline_url(timeline)
        xml.guid timeline_url(timeline)

        text = timeline.frame
        # if you like, do something with your content text here e.g. insert image tags.
        # Optional. I'm doing this on my website.
        if timeline.picture_url.present?
          image_url = timeline.picture_url
          image_align = "center"
          image_tag = "
                <p><img src='" + image_url +  "' alt='" + timeline.slug + "' title='" + timeline.name + "' align='" + image_align  + "' /></p>
              "
          text += image_tag
        end
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end