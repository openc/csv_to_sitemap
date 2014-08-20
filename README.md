# CsvToSitemap

Basic library for converting CSV file of paths to XML sitemap collection (i.e. with sitempa index)

## Installation

Add this line to your application's Gemfile:

    gem 'csv_to_sitemap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_to_sitemap

## Usage
require 'csv_to_sitemap'

CsvToSitemap.generate_from_csv_file('/tmp/dump.csv',:domain=>'example.com', :export_dir => '/path/to/sitemap)

## Usage
Write some specs?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
