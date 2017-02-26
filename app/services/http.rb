require 'net/http'
require 'uri'
require 'open-uri'
require 'json'
require 'open_uri_redirections'
require 'openssl'

module Shule
  class Http
    class << self
      def get_document(url, ssl_mode = true)
        charset = nil
        puts "open(#{url})"
        if ssl_mode
          html = open(url) do |f|
            charset = f.charset
            f.read
          end
        else
          html = open(url, allow_redirections: :safe, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |f|
            charset = f.charset
            f.read
          end
        end
        Nokogiri::HTML.parse(html, charset)
      rescue => e
        p e
        puts "error: get_document(#{url})"
        Nokogiri::HTML('')
      end

      def get_json(url, header = nil)
        puts "get_json: #{url}"
        url_escape = URI.escape(url)
        self.get_json_core(url_escape, 10, header)
      end

      def get_json_core(url, limit, header)
        raise ArgumentError, 'too many HTTP redirects' if limit == 0
        uri = URI.parse(url)
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.open_timeout = 5
          http.read_timeout = 10
          http.get(uri.request_uri, header)
        end
        case response
        when Net::HTTPSuccess
          json = response.body
          JSON.parse(json, symbolize_names: true)
        when Net::HTTPRedirection
          location = response['location']
          warn "redirected to #{location}"
          get_json_core(location, limit - 1)
        else
          puts [uri.to_s, response.value].join(' : ')
          # handle error
        end
      rescue => e
        puts [uri.to_s, e.class, e].join(' : ')
        # handle error
      end
    end
  end
end
