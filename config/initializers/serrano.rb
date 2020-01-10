require 'serrano'

Serrano.configuration do |config|
  config.base_url = "https://api.crossref.org"
  config.mailto = ENV['CROSSREF_EMAIL']
end