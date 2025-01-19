require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

redis_conn = { 
  url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0'),
  network_timeout: 5,
  timeout: 5,
  size: 27,
  reconnect_attempts: 3
}

Sidekiq.configure_server do |config|
  config.redis = redis_conn

  # Define a concorrência
  config.concurrency = ENV.fetch('SIDEKIQ_CONCURRENCY', 20).to_i

  # Define as filas e suas prioridades
  config.queues = [
    ['file_processing', 7],
    ['debt_processing', 5],
    ['bill_generation', 4],
    ['mailer', 1]
  ]
end

Sidekiq.configure_client do |config|
  config.redis = redis_conn.merge(size: 5)
end
