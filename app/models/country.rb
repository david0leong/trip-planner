# frozen_string_literal: true

# Country wrapper
class Country
  attr_accessor :id,
                :iso2_code,
                :name,
                :capital,
                :latitude,
                :longitude
  def self.distance(country1, country2)
    Geocoder::Calculations.distance_between(
      [country1.latitude, country1.longitude],
      [country2.latitude, country2.longitude]
    )
  end

  def initialize(data = {})
    symbolized_data = data.deep_symbolize_keys

    @id = symbolized_data.dig(:id)
    @iso2_code = symbolized_data.dig(:iso2Code)
    @name = symbolized_data.dig(:name)
    @capital = symbolized_data.dig(:capitalCity)
    @latitude = symbolized_data.dig(:latitude).to_f
    @longitude = symbolized_data.dig(:longitude).to_f
  end

  def [](key)
    send(key) if respond_to?(key)
  end

  def as_json
    {
      id: id,
      iso2_code: iso2_code,
      name: name,
      capital: capital,
      latitude: latitude,
      longitude: longitude
    }
  end

  def to_json(*_args)
    as_json.to_json
  end

  def in_boundary?(boundary)
    between_latitudes?(boundary[:min_latitude], boundary[:max_latitude]) &&
      between_longitudes?(boundary[:min_longitude], boundary[:max_longitude])
  end

  def between_latitudes?(min, max)
    latitude.between?(min, max)
  end

  def between_longitudes?(min, max)
    if max < min
      longitude.between?(min, 180) || longitude.between?(-180, max)
    else
      longitude.between?(min, max)
    end
  end
end
