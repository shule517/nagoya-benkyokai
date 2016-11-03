# encoding: utf-8
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'

class Http
  def self.get_document(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    Nokogiri::HTML.parse(html, charset)
  end

  def self.get_json(url)
    url_escape = URI.escape(url)
    uri = URI.parse(url_escape)
    json = Net::HTTP.get(uri)
    JSON.parse(json, {:symbolize_names => true})
  end
end
