Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN'] if ENV.has_key?('SENTRY_DSN')
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
