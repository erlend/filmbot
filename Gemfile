source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use PostgreSQL as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Use slim for html templates
gem 'slim-rails'
# Use Bootstrap as HTML/CSS framewor
gem 'bootstrap', '~> 4.0.0.alpha6'
# Communicate with APIs using RestClient
gem 'rest-client', '~> 2.0.0'

# Trello related
gem 'omniauth-trello'
gem 'ruby-trello', '~> 2.0.0', require: 'trello'

# Use Pickup to pick a movie by it's votes
gem 'pickup'

# Use Sentry for error tracking
gem 'sentry-raven'

group :development, :test do
  # Use RSpec as test suite
  gem 'rspec-rails', '~> 3.5'
  # Use Factory Girl instead of fixtures
  gem 'factory_girl_rails', '~> 4.6'
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
  # Use Capybar for integration testing
  gem 'capybara', require: 'capybara/rspec'
  # Clean out the database between tests
  gem 'database_cleaner'
  # Generate fake data for tests
  gem 'ffaker'
  # Make assertions on HTML
  gem 'rspec-html-matchers'
  # Stub external requests
  gem 'vcr'
  gem 'webmock', require: 'webmock/rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
