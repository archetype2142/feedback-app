Sidekiq.configure_server do |config|
  config.logger.level = Logger::DEBUG
end

Sidekiq.configure_client do |config|
  config.logger.level = Logger::DEBUG
end
