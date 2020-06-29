# frozen_string_literal: true

# Base class for all services that have #call interface
class FindCapitalsInBoundary < BaseService
  def initialize(countries, boundary)
    @countries = countries
    @boundary = boundary
  end

  def call
    countries.select { |c| c.in_boundary?(boundary) }
  end

  private

  attr_reader :countries, :boundary
end
