source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sassc-rails'
gem 'jquery-rails'
gem 'uglifier'

gem 'omniauth'
gem 'omniauth-cas'
gem 'cancancan'

gem 'slim'
gem 'slim-rails'
gem 'formtastic'
gem 'formtastic-bootstrap'

gem 'therubyracer'
gem 'exception_notification'

gem 'httpx'

group :development, :dev, :preprod, :production do
  gem 'activerecord-oracle_enhanced-adapter'
  gem 'ruby-oci8', '~> 2.2', '>= 2.2.2'
  gem 'pg'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'listen'
  gem 'dotenv-rails'
end

group :development do
  gem 'yaml_db'
end

# delayed job stuff
gem 'delayed_job_active_record'
gem 'activejob_dj_overrides' # gives us per-job overrides in active_job (like delayed_job)
gem "delayed_job_web"
gem 'sinatra' #, git: 'https://github.com/sinatra/sinatra.git', require: false

# we don't need this gem in production environment, but we need to have the gem available for assets:precompile (env=production)
# we don't mount the gem's engine in routes.rb in production and test environments so there's no endpoint there
gem 'letter_opener_web'

group :test do
  gem 'rspec', '~>3.5'
  gem 'rspec-rails', '~>3.5'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
