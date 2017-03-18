Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :trello, ENV['TRELLO_CONSUMER_KEY'], ENV['TRELLO_CONSUMER_SECRET'],
    app_name: "FilmBot", scope: 'read,write,account', expiration: 'never'
end
