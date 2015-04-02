workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads 0, Integer(ENV['WORKER_CONCURRENCY'] || 4)

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'staging'

preload_app!