# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authorization_token
    (request.headers['Authorization'] || '').split(' ').last
  end

  def authenticate
    render json: { error: 'Unauhorized' }, status: :unauthorized if authorization_token != ENV['AUTHORIZATION_TOKEN']
  end
end
