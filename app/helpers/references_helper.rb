module ReferencesHelper
  class ConnectionError < StandardError
  end

  def fetch_reference(query)
    raise ArgumentError, "Doi was blank when trying to fetch metadata from external sources" if query.blank?
    begin
      ref_json = Serrano.works(ids: query).first["message"]
      Reference.new(journal: ref_json["container-title"].first,
                    author: ref_json["author"].map { |a| a["given"] + " " + a["family"] }.join(", "),
                    title: ref_json["title"].first,
                    doi: ref_json["DOI"],
                    year: ref_json["created"]["date-parts"].first.first,
                    url: ref_json["URL"],
                    abstract: (ref_json.has_key? "abstract") ? ref_json["abstract"].sub("<jats:p> ", '').chomp(" </jats:p>") : "",
                    open_access: !ref_json["content-domain"]["crossmark-restriction"])
    rescue Serrano::NotFound
      raise ArgumentError, "Search from CrossRef produced no ref_json, the DOI or name may be incomplete"
    rescue
      raise ConnectionError, "Could not connect to the crossref server"
    end
  end
end
