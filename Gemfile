# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# CORE

### Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3.7'
gem 'rails-i18n', '~> 6.0.0'

### Use Puma as the app server
gem 'puma', '~> 4.1'

### Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Load .env files in development and test
gem 'dotenv-rails', groups: %i[development test], require: 'dotenv/rails-now'

### ActiveRecord Pagination
gem 'kaminari', '~> 1.2.0'

### Character Encoding
gem 'charlock_holmes', '0.7.7'

### DE ### Ruby dep incompatible with ruby 3.0 #45 https://github.com/samesies/barber-jekyll/issues/45
# gem "jekyll", "~> 3.9"
gem "webrick", "~> 1.7"
gem "kramdown-parser-gfm"
gem 'execjs', '2.7.0'

# FRONTEND

## HTML & Views

### HAML templates
gem 'haml-rails'

### Bootstrap
gem 'autoprefixer-rails', '~> 10.1.0.0'
gem 'bootstrap'
gem 'bootstrap_form', '>= 4.0.0'
gem 'cocoon'

### Searching / Sorting
gem 'ransack'

# CSS

### Use SCSS for stylesheets
gem 'sass-rails', '~> 6'

# JavaScript

### Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
### Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'

### Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
gem 'psych', '<4'

### Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

### Use jquery as the JavaScript library
gem 'jquery-rails'

### Active Storage Variants
gem 'image_processing'

# JSON API

# Fast JSON API implementation by Netflix
# @see https://jsonapi.org/
gem 'fast_jsonapi'

# Parse JSON API request bodies and expose parameters in format Rails expects
gem 'jsonapi_parameters'

# RACK MIDDLEWARE

### Browser/platform detection
gem 'browser'

# ASSETS

### Validations for ActiveStorage attachments
gem 'active_storage_validations', '~> 0.8.8'

### Remote storage adapter (Amazon S3)
gem 'aws-sdk-cloudwatchlogs', '~> 1.34.0', require: false
gem 'aws-sdk-medialive', '~> 1.44.0', require: false
gem 'aws-sdk-mediastore', '~> 1.24.0', require: false
gem 'aws-sdk-s3', '~> 1.62.0', require: false

# LOCALISATION & TIME ZONES

### Timezone data (missing from our minimal docker image)
gem 'tzinfo-data'

# AUTHENTICATION

### Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# AUTHORIZATION

### Use CanCanCan for authorizing actions
gem 'cancancan', '~> 3.1.0'

# DATABASE

### Use mysql as the database for Active Record
gem 'mysql2', '>= 0.5.3'

# ENGINES & ACTIVERECORD EXTENSIONS

# ERROR LOGGING

### Error reporting to an Errbit server
gem 'airbrake', '~> 10.0'

# EXTERNAL APIS & SERVICES INTEGRATIONS

### Chat application integration

gem 'cometchat', '0.6.1'

### Push notifications integration
gem 'fcm', '~> 1.0.1'

# RAKE TASKS & BACKGROUND JOBS

### ActiveJob Adapter
gem 'sidekiq', '~> 6.0.7'

group :development do
  # DOCUMENTATION

  ### Documentation server - see README.md
  gem 'sdoc', require: false

  # DEVELOPMENT TOOLS

  ## ONLY AVAILABLE IN DEVELOPMENT

  ### Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  ### Run scripts when changes on the filesystem occur
  gem 'guard', require: false

  ### Run test suite when source code changes
  gem 'guard-rspec', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Dependency of web-console
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Linting
  gem 'rubocop-dubit', '~> 1.0.1'

  # Development Emails
  gem 'letter_opener'

  # Block external calls
  gem 'webmock', '~> 3.8.3'
end

## ENABLED IN DEVELOPMENT AND TEST, BUT ALSO AVAILABLE AS NEEDED IN PRODUCTION

# Nicer formatting of console output - enable with ENABLE_AWESOME_PRINT env var
gem 'awesome_print', require: false

# TESTING TOOLS

group :test do
  # Test Framework
  gem 'rspec-rails', '~> 3.8.2'

  # Test assertions
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'

  # Test factories
  gem 'factory_bot_rails'

  # Test coverage
  gem 'simplecov', require: false
end
