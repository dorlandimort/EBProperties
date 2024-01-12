# frozen_string_literal: true

require 'dotenv/load'
require 'faraday'

module EasyBroker
  ##
  # HTTP client for EasyBroker API.
  # @see https://dev.easybroker.com/reference
  ##
  class Client
    ##
    # @param api_key [String] The API key to be used for authentication.
    # @param base_url [String] The base URL to be used for the API calls.
    ##
    def initialize(api_key: DEFAULT_API_KEY, base_url: BASE_URL)
      @api_key = api_key
      @base_url = base_url
    end

    attr_reader :api_key, :base_url

    DEFAULT_API_KEY = ENV.fetch('EASY_BROKER_API_KEY')
    BASE_URL = 'https://api.stagingeb.com'

    ##
    # Makes a GET request to the EasyBroker API to the given +path+ with the given +params+.
    # @param path [String] The path to the resource to be requested.
    # @param params [Hash] The parameters to be sent with the request.
    # @return [Faraday::Response] The response from the EasyBroker API.
    #
    # @example
    # EasyBroker::Client.new.get(path: '/properties', params: { city: 'Mexico City' })
    # # => { "properties": [{ "id": 1, "name": "Property 1" }, { "id": 2, "name": "Property 2" }] }
    ##
    def get(path:, params: {})
      connection.get(path, params)
    end

    private

    def connection
      @connection ||= Faraday.new(url: base_url, headers:, request: { timeout: 5 }) do |conn|
        conn.request :json
        conn.response :json
        conn.response :raise_error, include_request: true
      end
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'X-Authorization' => api_key
      }
    end
  end
end
