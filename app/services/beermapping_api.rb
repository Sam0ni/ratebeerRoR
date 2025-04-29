class BeermappingApi
  def self.places_in(city)
    url = "https://studies.cs.helsinki.fi/beermapping/locations/"

    res = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = res.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end
end