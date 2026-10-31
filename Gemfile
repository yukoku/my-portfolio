source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.7'

gem 'rails', '~> 7.0.8'
gem 'sprockets-rails'
gem 'bootstrap-sass', '>= 3.3.7'
gem 'jquery-rails', '~> 4.3.5'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 6.4'
gem 'sass-rails', '~> 6.0'
gem 'terser', '~> 1.2'
gem 'coffee-rails', '~> 5.0'
gem 'jbuilder', '~> 2.5'
gem 'mini_magick', '~> 4.8'
# ActiveStorage の variant（サムネイル生成）で本番環境でも使用する
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.12.0', require: false

# https://qiita.com/Taira0222/items/89fe772eb8d752da4db7
gem 'concurrent-ruby', '1.3.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 6.1'
  gem 'simplecov', '>= 0.17.0'
  gem 'capybara', '~>3.39'
  gem 'launchy', '~> 2.4.3'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'database_rewinder', '>= 0.9.1'
  gem 'shoulda-matchers'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.2'
  gem 'listen', '~> 3.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.1'
  gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'letter_opener', '>= 1.0'
  gem 'letter_opener_web', '>= 1.3.4'
  gem 'lol_dba', '>= 2.1.8'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :production do
  gem 'aws-sdk-s3', '~> 1.46', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise', '~> 4.9'
gem 'devise_invitable', '~> 2.0.9'
gem 'devise-i18n', '~> 1.12'
gem 'devise-i18n-views', '~> 0.3'
gem 'validates_timeliness', '~> 7.0'
gem 'faker', '~> 2.1'      # production環境でも使用する
gem 'kaminari', '~> 1.2'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'gretel', '~> 4.4'
gem 'ransack', '~> 4.1'
