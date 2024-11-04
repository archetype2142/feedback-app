sidekiq_config = { 
  url: ENV['REDIS_URL'],
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
}

Sidekiq.configure_server do |config|
  config.logger.level = Logger::DEBUG
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.logger.level = Logger::DEBUG
  config.redis = sidekiq_config
end

Sidekiq.default_job_options = { 'backtrace' => true }
