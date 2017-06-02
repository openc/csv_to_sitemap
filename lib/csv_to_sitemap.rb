require "csv_to_sitemap/version"
# require 'debugger'
require 'csv'

module CsvToSitemap
  extend self

  XML_INDEX_WRAPPER_START = <<-HTML
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
    http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd"
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
>
  HTML

  XML_INDEX_WRAPPER_END = "</sitemapindex>"

  XML_WRAPPER_START = <<-HTML
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
  xmlns:video="http://www.google.com/schemas/sitemap-video/1.1">
HTML

  XML_WRAPPER_END = "</urlset>"

  ENTRIES_PER_FILE = 40000

  def add_to_sitemap_file(row_data, row_counter)
    # skip non-dates, and log fact
    unless row_data&&row_data[:lastmod]&&row_data[:lastmod][/^\d\d\d\d-\d\d-\d\d/]
      puts "Bad row data: #{row_data}"
      return
    end
    if row_counter%ENTRIES_PER_FILE == 0
      close_current_sitemap_file if @current_sitemap_file
      @file_counter += 1
      # ...write to sitemap_index_file
      @sitemap_index_file.puts sitemap_index_entry(@file_counter)
      # ...and open a new one
      @current_sitemap_file = File.new(File.join(@export_dir, "sitemap#{@file_counter}.xml"),'w')
      @current_sitemap_file.puts XML_WRAPPER_START
    end
    @current_sitemap_file.puts sitemap_entry(row_data)
  end

  def convert_row(csv_row)
    csv_hash = csv_row.to_hash
    {:lastmod => csv_hash['updated_at'], :loc => "#{@protocol}://#{@domain}/#{csv_hash['path']}"}
  end

  def generate_from_csv_file(csv_file, options={})
    @domain = options[:domain]
    @export_dir = options[:export_dir]||'/tmp'
    @protocol = options[:protocol]||'http'
    headers = options[:headers]||true
    @file_counter = row_counter = file_byte_counter = 0
    @sitemap_index_file = File.new(File.join(@export_dir, 'sitemap.xml'),'w')
    @sitemap_index_file.puts XML_INDEX_WRAPPER_START
    CSV.foreach(csv_file, :headers => headers) do |row|
      add_to_sitemap_file(convert_row(row), row_counter)
      row_counter += 1
    end
    close_current_sitemap_file if @current_sitemap_file
    @sitemap_index_file.puts XML_INDEX_WRAPPER_END
    @sitemap_index_file.close
  end

  def sitemap_index_entry(counter)
    entry = <<-HTML
    <sitemap>
      <loc>http://#{@domain}/sitemap/sitemap#{counter}.xml.gz</loc>
      <lastmod>#{Time.now.iso8601.sub(/Z$/i, '+00:00')}</lastmod>
    </sitemap>
    HTML
  end

  def sitemap_entry(entry)
    builder = ::Builder::XmlMarkup.new# if builder.nil?
    builder.url do
      builder.loc        entry[:loc]
      builder.lastmod    entry[:lastmod]      if entry[:lastmod]
      # builder.expires    w3c_date(self[:expires])      if self[:expires]
      # builder.changefreq self[:changefreq].to_s        if self[:changefreq]
      # builder.priority   format_float(self[:priority]) if self[:priority]
    end
    builder << '' # Force to string
  end

  def close_current_sitemap_file
    @current_sitemap_file.puts XML_WRAPPER_END
    @current_sitemap_file.close
  end
end
