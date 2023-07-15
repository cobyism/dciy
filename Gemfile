source 'https://rubygems.org'
#ruby "2.0.0"

# Rails
gem 'rails', '>=5.2'
gem 'sqlite3', '=1.6.1' 
gem 'sass-rails', '=6.0.0'
gem 'uglifier', '=4.2.0'
gem 'coffee-rails', '=5.0.0'
gem 'jquery-rails', '=4.5.1'
gem 'turbolinks', '=5.2.1'
gem 'jbuilder', '=2.11.5'

# This App
gem 'dotenv-rails'
gem 'foreman'
gem 'rest-client'
gem 'sidekiq'
#gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sinatra' 
gem 'toml'
gem 'puma'

group :development do
  gem 'rubocop', require: false
  gem 'brakeman'
  gem "capistrano", "~> 3.17", require: false
end

group :test do 
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'rails-controller-testing', '=1.0.5'
end

group :development, :test do 
  gem "pry"
  gem "pry-nav"
end
