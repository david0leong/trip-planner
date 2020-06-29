# frozen_string_literal: true

# Country wrapper
class Country
  attr_accessor :id,
                :iso2_code,
                :name,
                :capital,
                :latitude,
                :longitude

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
    latitude.between?(boundary[:min_latitude], boundary[:max_latitude]) &&
      longitude.between?(boundary[:min_longitude], boundary[:max_longitude])
  end
end
