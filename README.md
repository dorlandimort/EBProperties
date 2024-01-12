# EB Properties API consumer

This is a simple API consumer for the EB Properties API. It is written in Ruby 3.2.

## Requirements
- Ruby 3.2
- Bundler

## Installation
- Clone the repository
- Create a `.env` file and add the content from `.env.example` to it. Then, add your EB API key to the `EASY_BROKER_API_KEY` variable.
- Run `bundle install`
- Run `bundle exec rspec` to run the tests

## Usage
- Run `bundle exec ruby -Ilib lib/runner.rb` to run the application. This will print all the EB properties' titles to STDOUT.
Example output (it might take a while because it first loads all the properties from the API):
```
Bodega en Naucalpan
Casa en Renta en Residencial Privada Jardín, Juárez, N.L.
Casa en Renta en Col. Obrerista en Monterrey, N.L.
Casa en Venta en Nuevo Amanecer en Apodaca, N.L.
Casa en Venta en Fracc. Los Candiles en Apodaca, N.L.
Casa en Venta en Col. Lomas del Topo Chico en Monterrey, N.L.
```
