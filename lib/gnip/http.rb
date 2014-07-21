require 'rest-client'

module Gnip
  module HTTP
    def self.get(url)
      make_request(:get, url)
    end

    def self.put(url, data)
      make_request(:put, url, {payload: data})
    end

    def self.post(url, data)
      make_request(:post, url, {payload: data})
    end

    private

    def self.make_request(method, url, opts={})
      begin
        RestClient::Request.new(opts.merge!({method: method, user: GNIP_USERNAME, password: GNIP_PASSWORD, url: url, timeout: 30, open_timeout: 30, headers: {accept: :json}})).execute
      rescue => e
        unless e.response.nil?
          if e.response.code == 400
            raise InvalidRequestException.new(e.response.inspect)
          else
            raise e
          end
        end
      end
    end
  end
end
