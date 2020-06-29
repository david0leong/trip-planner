# frozen_string_literal: true

class Api::V1::CountriesController < ApplicationController
  def show
    country_response = api_client.country(code_params[:code].downcase)[1][0]
    country = Country.new country_response

    render json: country.as_json
  rescue ApiError => e
    render json: { error: e.to_s }, status: e.status
  end

  def capitals
    validate_boundary_params!

    countries_response = api_client.countries[1]
    countries = FilterCountries.call(countries_response)
    capitals = FindCapitalsInBoundary.call(countries, clean_boundary_params)

    render json: capitals.map(&:as_json)
  rescue StandardError => e
    render json: { error: e.to_s }, status: :unprocessable_entity
  end

  def visit
    validate_visit_params!

    countries_response = api_client.countries[1]
    countries = FilterCountries.call(countries_response)
    path = VisitCapitals.call(countries, visit_params[:capitals])

    render json: path
  rescue StandardError => e
    render json: { error: e.to_s }, status: :unprocessable_entity
  end

  private

  def api_client
    @api_client ||= ::WorldBankApi::V2::Client.new
  end

  def code_params
    params.permit(:code)
  end

  def bounary_params
    params.permit(:min_latitude, :min_longitude, :max_latitude, :max_longitude)
  end

  def validate_boundary_params!
    raise 'Invalid params' if bounary_params[:min_latitude].blank? ||
                              bounary_params[:min_longitude].blank? ||
                              bounary_params[:max_latitude].blank? ||
                              bounary_params[:max_longitude].blank?
  end

  def clean_boundary_params
    bounary_params
      .to_h
      .transform_values(&:to_f)
      .deep_symbolize_keys
  end

  def visit_params
    params.permit(capitals: [])
  end

  def validate_visit_params!
    raise 'Please provide 4 capitals' if visit_params[:capitals].size != 4
  end
end
