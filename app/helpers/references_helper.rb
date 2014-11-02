module ReferencesHelper
  def fetch_from_crossref
    if not @reference.doi.blank?
      cross_ref = Faraday.new(:url => 'http://search.crossref.org')
      response = cross_ref.get '/dois', {:q => @reference.title_en} do |request|
        request.headers['Content-Type'] = 'application/json'
      end
      if response.status == 200
      output = JSON.parse(response.body)[0]
        if output.nil?
          @reference.title = ''
          @reference.doi = ''
          @reference.year = ''
          @reference.journal = ''
          @reference.author = ''
        else
          conn = Faraday.new( output["doi"] ) { |req|
            req.use FaradayMiddleware::FollowRedirects
            req.adapter Faraday.default_adapter
          }
          conn.headers[:Accept] ='application/x-bibtex'
          resp = conn.get
          if resp.status == 200
            bib = BibTeX.parse(resp.body)[0]
            @reference.title_en = if bib.respond_to?(:title) then bib.title.value else '' end
            @reference.doi = if bib.respond_to?(:doi) then bib.doi.value else '' end
            @reference.year = if bib.respond_to?(:year) then bib.year.value else '' end
            @reference.url = if bib.respond_to?(:url) then bib.url.value else '' end
            @reference.journal = if bib.respond_to?(:journal) then bib.journal.value else '' end
            @reference.author = if bib.respond_to?(:author) then bib.author.value else '' end
          else
            fullcit = output["fullCitation"]
            if fullcit.split("<i>")[1]
              @reference.journal = fullcit.split("<i>")[1].split("</i>")[0]
              @reference.author = fullcit.split("<i>")[0].split(",")[0..-4].join(",")
            else
              @reference.journal = ''
              @reference.author = ''
            end
            @reference.title = ''
            @reference.title_en = output["title"]
            @reference.doi = output["doi"]
            @reference.year = output["year"]
          end
        end
      end
    end
  end
end