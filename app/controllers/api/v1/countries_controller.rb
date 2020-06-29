# frozen_string_literal: true

class Api::V1::CountriesController < ApplicationController
  def show
    country = api_client.country(params[:code])[1][0]
    render json: country.slice('name', 'capitalCity')
  rescue ApiError => e
    render json: { error: e.to_s }, status: e.status
  end

  private

  def api_client
    @api_client ||= ::WorldBankApi::V2::Client.new
  end

  def show_params
    params.permit(:code)
  end
end
