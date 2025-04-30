class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_at: 1.minute.from_now) { get_places_in(city) }
  end


  def self.get_places_in(city)
    url = "https://studies.cs.helsinki.fi/beermapping/locations/"

    res = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = res.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.place_with_id(id, city)
    places = places_in(city)
    places.find { | place | place.id == id}
  end
end