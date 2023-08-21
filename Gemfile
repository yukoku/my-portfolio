source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'

gem 'rails', '~> 5.2.3'
gem 'bootstrap-sass', '>= 3.3.7'
gem 'jquery-rails', '~> 4.3.5'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 5.6', '>= 5.6.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'simplecov', '>= 0.17.0'
  gem 'capybara', '~>2.15.2'
  gem 'launchy', '~> 2.4.3'
  gem 'webdrivers', '~> 4.1'
  gem 'factory_bot_rails', '~> 5.0'
  gem 'database_rewinder', '>= 0.9.1'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1.0'
  gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener', '>= 1.0'
  gem 'letter_opener_web', '>= 1.3.4'
  gem 'lol_dba', '>= 2.1.8'
  gem 'bullet', '>= 6.0.1'
end

group :production do
  gem 'aws-sdk-s3', '~> 1.46', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise', '~> 4.7.1'
gem 'devise_invitable', '~> 2.0.0'
gem 'devise-i18n', '~> 1.8'
gem 'devise-i18n-views', '~> 0.3'
gem 'validates_timeliness', '~> 5.0.0.alpha3'
gem 'faker', '~> 2.1'      # production環境でも使用する
gem 'kaminari', '~> 1.1'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'gretel', '~> 3.0'
gem 'ransack', '~> 2.1'
