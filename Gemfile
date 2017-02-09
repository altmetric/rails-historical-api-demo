source 'https://rubygems.org'

# Application
gem 'rake'
gem 'rails', '~> 4.0.8'
gem 'rest-client', '~> 1.6.7'
gem 'yajl-ruby', '~> 1.2.1'

# Assets
gem 'bower-rails', '~> 0.7.3'
gem 'jquery-rails'
gem 'coffee-rails'
# Cannot use bootstrap-sass from bower because it's too out-of-date
gem 'less-rails' # required for bootstrap
gem 'sass-rails', '~> 4.0.2'
gem 'slim-rails'
gem 'autoprefixer-rails'
gem 'handlebars_assets'
gem 'uglifier'
gem 'eventmachine', '~> 1.0.4'

gem 'dotenv-rails'

group :test do
  gem 'webmock', '~> 1.18.0'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'jasmine-rails'
  gem 'sinon-rails'
end

group :development, :test do
  gem 'coffee-rails-source-maps'
end

group :production do
  gem 'therubyracer'
  gem 'thin', '~> 1.6.2'
end

group :development do
  gem 'quiet_assets'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-coffeescript'
  gem 'guard-jasmine'
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9'
end

group :test do
  gem 'simplecov', '~> 0.8.2', :require => false
  gem 'simplecov-rcov', '~> 0.2.3', :require => false
end
