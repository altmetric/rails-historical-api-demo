# Load the Rails application.
require File.expand_path('../application', __FILE__)

GNIP_ACCOUNT = ENV['GNIP_ACCOUNT']
GNIP_USERNAME = ENV['GNIP_USERNAME']
GNIP_PASSWORD = ENV['GNIP_PASSWORD']

# Initialize the Rails application.
GnipHistoricalManagerator::Application.initialize!
