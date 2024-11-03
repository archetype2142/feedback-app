# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.4'

gem 'zip-zip'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'devise'
gem 'kaminari'
gem 'pg'
gem 'ransack'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-scheduler'
gem 'sprockets-rails'
gem 'tailwindcss-rails'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mswin mswin64 mingw x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
gem 'rack-cors'
gem 'chartkick'
gem 'groupdate'
gem 'sentimental'
gem 'browser'
gem 'request_store'
gem 'json'
gem 'chatgpt-ruby'
gem 'httparty'
gem 'tf-idf-similarity'  # For keyword extraction
gem 'roo'  # For Excel export
gem 'axlsx'  # For Excel generation
gem 'ruby-openai'
gem 'dotenv-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw]
  gem 'letter_opener'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'byebug'
  gem 'foreman', '~> 0.87.2'
  gem 'rubocop', '~> 1.35.0'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
