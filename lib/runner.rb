# frozen_string_literal: true

require 'easy_broker/properties'
require 'easy_broker/client'

properties = []
path = '/v1/properties'
http_client = EasyBroker::Client.new # To re-use the same http client across requests in a loop

loop do
  properties_info = EasyBroker::Properties.fetch_properties(path:, http_client:)
  path = properties_info.dig('pagination', 'next_page')
  properties.append(*properties_info['properties'])

  break if path.nil?
rescue Faraday::ClientError => e
  raise unless e.response[:status] == 429

  sleep(1.second) # EB API rate limit is 20 requests per second
  retry
end

# First format the properties to be printed into a single String to avoid making N IO calls
puts EasyBroker::Properties.format_properties_titles(properties:)
