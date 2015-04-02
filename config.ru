require 'sinatra'
require 'refile'
require 'refile/backend/s3'
require 'refile/app'

set :app_file, __FILE__
set :environments, %w(test development staging production)
set :show_exceptions, settings.environment != :production

puts 'hallo'

require 'sinatra/base'

HalloWelt = Rack::Builder.new do
  map '/attachments' do
    run Refile::App
  end
end

run HalloWelt


# Refile.configure do |config|
#   max_size = 10.megabytes
#
#   if Rails.env.test?
#     config.cache = Refile::Backend::FileSystem.new('tmp/refile/cache', max_size: max_size)
#     config.store = Refile::Backend::FileSystem.new('tmp/refile/store', max_size: max_size)
#   else
#     aws = {
#       access_key_id: ENV['AWS_ACCESS_KEY'],
#       secret_access_key: ENV['AWS_SECRET_KEY'],
#       bucket: ENV['AWS_BUCKET'],
#       region: ENV['AWS_REGION'],
#       max_size: max_size
#     }
#
#     config.cache = Refile::Backend::S3.new(prefix: 'cache', **aws)
#     config.store = Refile::Backend::S3.new(prefix: 'store', **aws)
#   end
#
#   # Secretkey for signing urls
#   config.secret_key = ENV['REFILE_SECRET_KEY']
#
#   # Configure the request origin
#   config.allow_origin = '*'
#
#   # cloudfront or our server
#   config.host = "//#{ENV['REFILE_HOST']}"
# end
#
# run Refile::App