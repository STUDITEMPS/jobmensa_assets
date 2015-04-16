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

if logentries_key = ENV['LOGENTRIES_TOKEN']
  require 'le'
  Refile.logger = Le.new(logentries_key, log_level: Logger::INFO)
else
  Refile.logger = Logger.new("log/#{settings.environment}.log")
  Refile.logger.level = Logger::DEBUG
end

# configure rollbar
if rollbar_key = ENV['ROLLBAR_ACCESS_TOKEN']
  require 'rollbar'
  Rollbar.configure do |config|
    config.access_token = rollbar_key
  end
end

# configure newrelic
configure :staging, :production do
  require 'newrelic_rpm'
end

jobmensa_assets_app = Rack::Builder.new do
  if (authorized_domain = ENV['BLITZ_AUTHORIZED_DOMAIN'])
    map "/#{authorized_domain}" do
      blitz_app = Sinatra.new { get('/') { '42' } }
      blitz_app.run!
    end
  end
  map '/attachments' do
    run Refile::App
  end
end

run jobmensa_assets_app
