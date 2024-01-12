# frozen_string_literal: true

require 'dotenv/load'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock

  # Avoid leaking sensitive data into VCR cassettes
  config.filter_sensitive_data('<FILTERED>') do |interaction|
    interaction.request.headers['X-Authorization']&.first
  end

  config.default_cassette_options = {
    persister_options: { downcase_cassette_names: true },

    # Strict matching by method, URI and body
    match_requests_on: %i[method uri body_as_json]
  }
end
