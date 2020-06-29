# frozen_string_literal: true

class FilterCountries < BaseService
  def initialize(raw_countries)
    @raw_countries = raw_countries
  end

  def call
    @raw_countries
      .select { |c| c['capitalCity'].present? }
      .map { |c| Country.new c }
  end
end
