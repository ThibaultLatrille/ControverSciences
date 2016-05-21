module ReferencesHelper
  class ConnectionError < StandardError
  end

  def fetch_reference( query )
    raise ArgumentError, "Doi was blank when trying to fetch metadata from external sources" if query.blank?

    ref_json = fetch_from_crossref(query)

    parse_ref_json(ref_json)
  end

  private

  def parse_ref_json(ref_json)
    ref = Reference.new
    fullcit = ref_json["fullCitation"]
    begin
      ref.journal = /<i>(.+)<\/i>/.match(fullcit)[1]
    rescue StandardError
      logger.warn "The citation doesn't contain journal."
      nil
    end
    begin
      authors_match = /^([\D]+,\s)*\d{4}/.match(fullcit)[1]
      ref.author = authors_match.nil? ? '' : authors_match[0..-3]
    rescue StandardError
      logger.warn "The citation doesn't contain authors."
      nil
    end
    ref.title = ref_json["title"]
    # DOI is parsed to remove leading "http://dx.doi.org/" to extract the actual DOI
    ref.doi = /^http:\/\/dx.doi.org\/(.*)/.match(ref_json["doi"])[1]
    ref.year = ref_json["year"]
    ref.url = find_real_url_for(ref_json["doi"])
    ref
  end

  def find_real_url_for(url_doi)
    conn = Faraday.new(url_doi) { |req|
      req.use FaradayMiddleware::FollowRedirects, limit: 10
      req.adapter Faraday.default_adapter
    }

    begin
      conn.get.env.url.to_s
    rescue Faraday::ConnectionFailed
      logger.warn "Couldn't fetch the real url for the reference #{url_doi}, the DOI service may be down."
      return url_doi
    rescue FaradayMiddleware::RedirectLimitReached
      logger.warn "Couldn't fetch the real url for the reference #{url_doi}, too many redirects."
      return url_doi
    end
  end

  def fetch_from_crossref(doi)
    cross_ref = Faraday.new(:url => 'http://search.crossref.org')
    begin
      response = cross_ref.get '/dois', {:q => doi} do |request|
        request.headers['Content-Type'] = 'application/json'
      end
    rescue Faraday::ConnectionFailed
      raise ConnectionError, "Could not connect to the crossref server"
    end

    raise ConnectionError, "Http request to crossref produced a #{response.status}" unless response.status == 200

    reference_json = JSON.parse(response.body)[0]

    raise ArgumentError, "Search from CrossRef produced no ref_json, the DOI or name may be incomplete" if reference_json.nil?
    reference_json
  end
end
