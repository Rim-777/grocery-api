source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.6"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem 'dry-validation', '~> 1.8'
gem 'dry-struct', '~> 1.6'
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'shopify-money', '~> 1.0.2.pre', require: 'money'
gem "rack-cors"
gem 'jsonapi-serializer', '~> 2.2'
gem 'rswag'
gem 'api-versions', '~> 1.2', '>= 1.2.1'
gem "sentry-ruby"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 4.0'
end

group :development do
  gem 'rubocop', require: false
  gem "spring"
end

group :test do
  gem 'shoulda-matchers', '~> 5.1'
  gem 'json_matchers', '~> 0.11.1'
end
