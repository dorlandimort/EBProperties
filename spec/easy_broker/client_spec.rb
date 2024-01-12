# frozen_string_literal: true

require 'easy_broker/client'

RSpec.describe EasyBroker::Client do
  subject(:client) { described_class.new }

  describe 'initialization' do
    it 'sets a default API key' do
      expect(client.api_key).to eq(described_class::DEFAULT_API_KEY)
    end

    it 'sets a default base URL' do
      expect(client.base_url).to eq(described_class::BASE_URL)
    end

    context 'when passing a custom API key' do
      subject(:client) { described_class.new(api_key:) }

      let(:api_key) { 'my-api-key' }

      it 'uses the custom API key' do
        expect(client.api_key).to eq(api_key)
      end
    end

    context 'when passing a custom base URL' do
      subject(:client) { described_class.new(base_url:) }

      let(:base_url) { 'https://example.com' }

      it 'uses the custom base URL' do
        expect(client.base_url).to eq(base_url)
      end
    end
  end

  vcr = 'easybroker_client/_get/1_2_1'

  describe '#get', vcr: do
    subject(:get) { client.get(path:, params:) }

    let(:path) { '/v1/properties' }
    let(:params) { { page: 3 } }

    it { is_expected.to be_a(Faraday::Response) }
    it { is_expected.to have_attributes(status: 200) }

    # Tests that the Faraday connection is configured correctly
    context 'when the request is not successful because of a client error', :vcr do
      let(:path) { '/v3/properties' } # This path does not exist

      it { expect { get }.to raise_error(Faraday::ClientError) }
    end

    context 'when the request is not successful because of a server error', vcr: false do
      before do
        stub_request(:get, %r{/v1/properties}).to_return(status: 500)
      end

      it { expect { get }.to raise_error(Faraday::ServerError) }
    end

    context 'when the used API key is invalid', :vcr do
      subject(:client) { described_class.new(api_key: 'invalid') }

      it { expect { get }.to raise_error(Faraday::UnauthorizedError) }
    end
  end
end
