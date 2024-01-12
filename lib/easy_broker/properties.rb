# frozen_string_literal: true

require 'easy_broker/client'

module EasyBroker
  ##
  # Service object that provides utilities to work with EasyBroker properties.
  ##
  module Properties
    ##
    # Creates a String with the titles of the given properties separated by a new line character.
    # @param properties [Array<Hash>] The properties to print the titles of.
    # @return [String] The titles of the given properties separated by a new line character.
    #
    # @example
    # properties = [{ title: 'Property 1' }, { title: 'Property 2' }]
    # Properties.print_property_titles(properties: properties)
    # # => "Property 1\nProperty 2"
    ##
    def self.format_properties_titles(properties:)
      properties.map { |property| property['title'] }.join("\n")
    end

    ##
    # Consumes the EasyBroker API to list properties. By default it attempts to fetch properties from the
    # +/v1/properties+ endpoint but a custom path can be passed. Additionally, it uses an instance of
    # +EasyBroker::Client+ with default configuration to make the request. It returns a +Hash+ mapping to the API
    # response +content+ and +pagination+ keys to +properties+ and +pagination+ respectively.
    #
    # @param path [String] The path to the resource to be requested.
    # @param http_client [EasyBroker::Client] The HTTP client to be used to make the request.
    # @return [Hash] A friendly hash with the +properties+ and +pagination+ information.
    #
    # @example Fetch the first page of properties
    # EasyBroker::Properties.fetch_properties
    # # => {
    # #   "properties": [ { "id": 1, "title": "Property 1" }, { "id": 2, "title": "Property 2" } ],
    # #   "pagination": { "next_page": "/v1/properties?page=2" }
    # # }
    #
    # @example Fetch a custom page of properties
    # EasyBroker::Properties.fetch_properties(path: '/v1/properties?page=2')
    # # => {
    # #   "properties": [ { "id": 3, "title": "Property 3" }, { "id": 4, "title": "Property 4" } ],
    # #   "pagination": { "next_page": "/v1/properties?page=3" }
    # # }
    #
    ##
    def self.fetch_properties(path: '/v1/properties', http_client: EasyBroker::Client.new)
      response = http_client.get(path:).body

      # Returning string keys for the hash to be consistent with the rest of the codebase
      { 'properties' => response['content'], 'pagination' => response['pagination'] }
    end
  end
end
