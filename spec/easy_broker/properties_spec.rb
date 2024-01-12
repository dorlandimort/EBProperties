# frozen_string_literal: true

require 'easy_broker/properties'

RSpec.describe EasyBroker::Properties do
  describe '.format_property_titles' do
    subject(:format_properties_titles) { described_class.format_properties_titles(properties:) }

    # Shortened version of a real response from the staging EasyBroker API
    let(:properties) do
      JSON.parse(<<~JSON)
        [
          {
            "public_id": "EB-B1027",
            "title": "Bodega en Naucalpan",
            "title_image_full": "https://assets.stagingeb.com/property_images/21027/29467/EB-B1027.jpg?version=1544817901",
            "title_image_thumb": "https://assets.stagingeb.com/property_images/21027/29467/EB-B1027_thumb.jpg?version=1544817901"
          },
          {
            "public_id": "EB-B4994",
            "title": "Casa en Renta en Residencial Privada Jardín, Juárez, N.L.",
            "title_image_full": "https://assets.stagingeb.com/property_images/24994/49091/EB-B4994.jpg?version=1555541680",
            "title_image_thumb": "https://assets.stagingeb.com/property_images/24994/49091/EB-B4994_thumb.jpg?version=1555541680",
            "location": "Privadas Jardines Residencial, Juárez, Nuevo León"
          }
        ]
      JSON
    end

    it { is_expected.to eq("Bodega en Naucalpan\nCasa en Renta en Residencial Privada Jardín, Juárez, N.L.") }

    context 'when properties is empty' do
      let(:properties) { [] }

      it { is_expected.to eq('') }
    end

    context 'when passing something that is not an array' do
      let(:properties) { 'not an array' }

      it 'raises an error' do
        expect { format_properties_titles }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.fetch_properties', :vcr do
    subject(:fetch_properties) { described_class.fetch_properties }

    let(:expected_result) do
      {
        'properties' => an_instance_of(Array),
        'pagination' => hash_including('next_page' => an_instance_of(String))
      }
    end

    it 'returns the API response but serialized' do
      expect(fetch_properties).to match(expected_result)
    end

    shared_context 'with mocked http client' do
      before do
        allow(EasyBroker::Client).to receive(:new).and_return(http_client)
        allow(http_client).to receive(:get).and_call_original
      end
    end

    context 'when passing a custom path' do
      subject(:fetch_properties) { described_class.fetch_properties(path:) }

      let(:path) { '/v1/properties?page=2' }
      let(:http_client) { EasyBroker::Client.new }

      include_context 'with mocked http client'

      it 'makes the request to the custom path' do
        fetch_properties
        expect(http_client).to have_received(:get).with(path:)
      end
    end

    context 'when passing a custom path but is not a properties path' do
      subject(:fetch_properties) { described_class.fetch_properties(path:) }

      let(:path) { '/v1/properties/EB-B1027' } # Actually fetching a single property not a list of properties
      let(:http_client) { EasyBroker::Client.new }
      let(:expected_incorrect_values) do
        {
          'properties' => be_nil,
          'pagination' => be_nil
        }
      end

      include_context 'with mocked http client'

      it 'returns incorrect values for properties and pagination' do
        expect(fetch_properties).to match(expected_incorrect_values)
      end
    end

    context 'when passing a custom http client' do
      subject(:fetch_properties) { described_class.fetch_properties(http_client:) }

      let(:http_client) { EasyBroker::Client.new }

      before do
        allow(http_client).to receive(:get).and_call_original
      end

      it 'uses the custom http client' do
        fetch_properties
        expect(http_client).to have_received(:get).with(path: '/v1/properties')
      end
    end
  end
end
