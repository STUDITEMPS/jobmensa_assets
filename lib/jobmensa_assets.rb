require 'jobmensa_assets/version'
require 'refile'
require 'jobmensa_assets/xt/refile/type'
require 'jobmensa_assets/xt/refile/backend/s3'
require 'jobmensa_assets/image_processor'
require 'jobmensa_assets/attachment_type'

if defined?(Rails)
  ENV['RAILS_ENV'] ||= Rails.env
  require 'jobmensa_assets/railtie'
  require 'refile/rails'
end

module JobmensaAssets
end
