require 'rubygems'
require 'bundler'
Bundler.require

require 'sinatra'

set :app_file, __FILE__
set :environments, %w(test development staging production)
set :show_exceptions, settings.environment != :production

$: << File.expand_path('lib')
require 'jobmensa_assets'
require 'jobmensa_assets/config'
require 'refile/app'

# init logger, not needed if inside of a rails app
require 'logger'
Refile.logger = if [:test, :development].include? settings.environment
  logger = Logger.new("log/#{settings.environment}.log")
  logger.level = Logger::DEBUG
  logger
else
  logger = Logger.new(STDOUT)
  logger.level = Logger::INFO
  logger
end

# configure rollbar
require 'rollbar'
if rollbar_key = ENV['ROLLBAR_ACCESS_TOKEN']
  Rollbar.configure do |config|
    config.access_token = rollbar_key
  end
end

# configure newrelic
configure :staging, :production do
  require 'newrelic_rpm'
end

jobmensa_assets_app = Rack::Builder.new do
  map '/attachments' do
    run Refile::App
  end
end

run jobmensa_assets_app