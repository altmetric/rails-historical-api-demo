require 'vcr'
require 'uri'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/cassettes'
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :webmock
  config.filter_sensitive_data('<GNIP_USERNAME>') { URI.encode_www_form_component ENV['GNIP_USERNAME'] }
  config.filter_sensitive_data('<GNIP_PASSWORD>') { URI.encode_www_form_component ENV['GNIP_PASSWORD'] }
  config.filter_sensitive_data('<GNIP_ACCOUNT>') { URI.encode_www_form_component ENV['GNIP_ACCOUNT'] }
end
