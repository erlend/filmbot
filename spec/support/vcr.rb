VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<TRELLO_CONSUMER_KEY>') { ENV['TRELLO_CONSUMER_KEY'] }
  config.filter_sensitive_data('<TRELLO_CONSUMER_SECRET>') { ENV['TRELLO_CONSUMER_SECRET'] }
  config.filter_sensitive_data('<TRELLO_OAUTH_TOKEN>') { ENV['TRELLO_OAUTH_TOKEN'] }
  config.filter_sensitive_data('<TRELLO_OAUTH_SECRET>') { ENV['TRELLO_OAUTH_SECRET'] }
  config.filter_sensitive_data('<TRELLO_PENDING_LIST_ID>') { ENV['TRELLO_PENDING_LIST_ID'] }
  config.filter_sensitive_data('<THEMOVIEDB_API_KEY>') { ENV['THEMOVIEDB_API_KEY'] }
end
