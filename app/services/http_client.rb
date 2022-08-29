# frozen_string_literal: true

require "net/http"

# Thin wrapper so that the implementation could be easily swapped out and replaced with alternatives
# Most probable candidate is https://rubygems.org/gems/faraday
class HttpClient
  class << self
    def post(url: nil, data: nil)
      raise HttpClientError.new("No URL provided", url) if url.blank?

      response = Net::HTTP.post(URI(url), data&.to_json)

      raise HttpClientError.new(
        "Response code is not 2XX, got #{response.code} instead", url
      ) unless response.is_a?(Net::HTTPSuccess)

      raise HttpClientError.new("Response is empty", url) if response.body.blank?

      begin
        JSON.parse(response.body)
      rescue JSON::ParserError
        raise HttpClientError.new("Response is not JSON-parseable", url)
      end
    end
  end

  class HttpClientError < StandardError
    def initialize(msg, url)
      super(msg + " for URL: #{url}")
    end
  end
end
