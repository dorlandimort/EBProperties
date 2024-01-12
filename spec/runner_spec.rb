# frozen_string_literal: true

RSpec.describe 'Runner' do
  subject(:run_easy_broker) { load('runner.rb') }

  let(:first_properties_page) do
    <<~JSON
      {
        "pagination": {
          "limit": 2,
          "page": 1,
          "total": 4,
          "next_page": "https://api.stagingeb.com/v1/properties?limit=2&page=2"
        },
        "content": [
          {
            "public_id": "EB-B1027",
            "title": "Bodega en Naucalpan"
          },
          {
            "public_id": "EB-B4994",
            "title": "Casa en Renta en Residencial Privada Jardín, Juárez, N.L."
          }
        ]
      }
    JSON
  end

  let(:second_properties_page) do
    <<~JSON
      {
        "pagination": {
          "limit": 2,
          "page": 2,
          "total": 4,
          "next_page": null
        },
        "content": [
          {
            "public_id": "EB-B4995",
            "title": "Casa en Renta en Col. Obrerista en Monterrey, N.L."
          },
          {
            "public_id": "EB-B4996",
            "title": "Casa en Venta en Nuevo Amanecer en Apodaca, N.L."
          }
        ]
      }
    JSON
  end

  let(:json_headers) do
    { 'Content-Type' => 'application/json' }
  end

  before do
    # Mock EB API so it returns 2 pages of 2 properties each
    stub_request(:get, %r{/v1/properties}).to_return(body: first_properties_page, headers: json_headers, status: 200)
    stub_request(:get, %r{/properties\?limit=2&page=2}).to_return(
      body: second_properties_page, headers: json_headers, status: 200
    )
  end

  # rubocop:disable RSpec/ExampleLength
  it 'prints all the properties titles' do
    expect { run_easy_broker }.to output(<<~OUTPUT).to_stdout
      Bodega en Naucalpan
      Casa en Renta en Residencial Privada Jardín, Juárez, N.L.
      Casa en Renta en Col. Obrerista en Monterrey, N.L.
      Casa en Venta en Nuevo Amanecer en Apodaca, N.L.
    OUTPUT
  end
  # rubocop:enable RSpec/ExampleLength
end
