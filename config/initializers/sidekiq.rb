Sidekiq.configure_server do |config|
  config.redis = { uri: 'redis:://localhost:6379/0'}
end

Sidekiq.configure_client do |config|
  config.redis = { uri: 'redis:://localhost:6379/0'}
end
