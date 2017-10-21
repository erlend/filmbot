source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Communicate with APIs using RestClient
gem 'rest-client', '~> 2.0.0'

# Trello related
gem 'ruby-trello', '~> 2.0.0', require: 'trello'

# Use Pickup to pick a movie by it's votes
gem 'pickup'

# Use Sentry for error tracking
gem 'sentry-raven'

# Use SuckerPunch for background jobs
gem 'sucker_punch', '~> 2.0'

group :development, :test do
  # Use RSpec as test suite
  gem 'rspec-rails', '~> 3.5'
  # Use dotenv for configuring
  gem 'dotenv-rails'
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-rails', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :test do
  # Make assertions on HTML
  gem 'rspec-html-matchers'
  # Stub external requests
  gem 'vcr'
  gem 'webmock', require: 'webmock/rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
