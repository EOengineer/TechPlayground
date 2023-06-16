# frozen_string_literal: true

require 'net/http'

module ApiClients
  class Base
    def initialize; end

    def get(path:, query: {})
      make_request(Net::HTTP::Get, path, query: query)
    end

    def post(path:, query: {}, body: {})
      make_request(Net::HTTP::Post, path, query: query, body: body, headers: headers)
    end

    def patch(path:, query: {}, body: {})
      make_request(Net::HTTP::Patch, path, query: query, body: body, headers: headers)
    end

    def put(path:, query: {}, body: {})
      make_request(Net::HTTP::Put, path, query: query, body: body, headers: headers)
    end

    def delete(path:, query: {})
      make_request(Net::HTTP::Delete, path, query: query)
    end

    private

    # define in subclass - required
    def base_url
      raise NotImplementedError, 'Base URL must be defined in subclass'
    end

    # subclasses can override to provide a different query builder
    def build_uri_query(query: {})
      Rack::Utils.build_query(query) if query.present?
    end

    # override in subclass for specialized headers
    def headers
      { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    end

    def make_request(klass, path, query: {}, headers: {}, body: {})
      uri = build_uri(path, query: query)

      http = build_connection(uri)

      request = klass.new(uri.request_uri, headers)

      if body.present?
        request.body = body.to_json
        request['Content-Type'] = 'application/json'
      end

      handle_response(http: http, request: request)
    end

    def build_uri(path, query: {})
      uri = URI(base_url + path)
      uri.query = build_uri_query(query: query)
      uri
    end

    def build_connection(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.instance_of?(URI::HTTPS)
      http
    end

    def handle_response(http:, request:)
      response = http.request(request)

      JSON.parse(response.body) if response.body.present?
    end
  end
end
