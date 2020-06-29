# frozen_string_literal: true

module WorldBankApi
  module V2
    class Client
      API_ENDPOINT = 'http://api.worldbank.org/v2'

      def initialize
        @client = Faraday.new(API_ENDPOINT) do |client|
          # client.use :http_cache, store: Rails.cache
          client.request :url_encoded
          client.adapter Faraday.default_adapter
          client.params[:format] = 'json'
        end
      end

      def countries
        request \
          http_method: :get,
          endpoint: 'country',
          params: { per_page: 400 }
      end

      def country(code)
        request \
          http_method: :get,
          endpoint: "country/#{code}"
      end

      private

      attr_reader :client

      def request(http_method:, endpoint:, params: {})
        response = client.public_send(http_method, endpoint, params)

        handle_response(response)
      end

      def handle_response(response)
        status = response.status
        body = JSON.parse(response.body)

        if body[0].key?('message')
          status = :bad_request
          message = body[0]['message'][0]['value']
        end

        raise ApiError.new(message, status: status) if status != 200

        body
      end
    end
  end
end
