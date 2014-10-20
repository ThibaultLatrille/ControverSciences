module ReferencesHelper

  def fetch_from_crossref
    if not @reference.title_en.blank?
      cross_ref = Faraday.new(:url => 'http://search.crossref.org')
      response = cross_ref.get '/dois', {:q => @reference.title_en} do |request|
        request.headers['Content-Type'] = 'application/json'
      end
      output = JSON.parse(response.body)[0]
      if output.nil?
        @reference.title = ''
        @reference.doi = ''
        @reference.year = ''
        @reference.journal = ''
        @reference.authors = ''
      else
        fullcit = output["fullCitation"]
        if fullcit.split("<i>")[1]
          @reference.journal = fullcit.split("<i>")[1].split("</i>")[0]
          @reference.authors = fullcit.split("<i>")[0].split(",")[0..-4].join(",")
        else
          @reference.journal = ''
          @reference.authors = ''
        end
        @reference.title = ''
        @reference.title_en = output["title"]
        @reference.doi = output["doi"]
        @reference.year = output["year"]
      end
    end
  end
end