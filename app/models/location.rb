class Location < ActiveRecord::Base
  belongs_to :user
  belongs_to :suggestion
  belongs_to :suggestionChild

  geocoded_by :ip_address   # can also be an IP address
  before_validation :geocode

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
end
