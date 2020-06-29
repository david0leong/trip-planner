# frozen_string_literal: true

class Api::V1::CountriesController < ApplicationController
  def show
    country_response = api_client.country(code_params[:code].downcase)[1][0]
    country = Country.new country_response

    render json: country.as_json.slice(:name, :capital)
  rescue ApiError => e
    render json: { error: e.to_s }, status: e.status
  end

  private

  def api_client
    @api_client ||= ::WorldBankApi::V2::Client.new
  end

  def code_params
    params.permit(:code)
  end
end
