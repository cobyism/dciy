source 'https://rubygems.org'
ruby "2.1.2"

# Rails
gem 'rails', '4.0.2'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

# This App
gem 'dotenv-rails'
gem 'foreman'
gem 'rest-client'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'toml'

group :development do
  gem 'rspec'
  gem 'rspec-rails'
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'rails_12factor'
  gem 'execjs'
  gem 'therubyracer'
  gem 'pg'
end
