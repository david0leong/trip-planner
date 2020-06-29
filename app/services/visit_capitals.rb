# frozen_string_literal: true

# Base class for all services that have #call interface
class VisitCapitals < BaseService
  def initialize(countries, capitals)
    @countries = countries
    @capitals = capitals
  end

  def call
    visit(capital_countries)
  end

  private

  attr_reader :countries, :capitals

  def capital_countries
    capitals.map do |capital|
      capital_country = countries.find { |country| country.capital == capital }

      raise "Invalid capital #{capital}" if capital_country.nil?

      capital_country
    end
  end

  def capital_distances(countries)
    distances = {}

    (0...countries.size).to_a.combination(2).each do |i, j|
      distances[[i, j]] = Country.distance(countries[i], countries[j])
    end

    distances
  end

  def visit(countries)
    distances = capital_distances(countries)
    shortest_path = nil
    shortest_distance = 0

    (0...countries.size).to_a.permutation(countries.size).each do |path|
      distance = path_distance(distances, path)

      if shortest_distance.zero? || shortest_distance > distance
        shortest_path = path
        shortest_distance = distance
      end
    end

    shortest_path.map { |i| countries[i].capital }
  end

  def path_distance(distances, path)
    (0...path.size - 1).reduce(0) do |sum, i|
      sum + distances[[path[i], path[i + 1]].sort]
    end
  end
end
