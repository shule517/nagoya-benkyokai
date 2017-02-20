source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: :development
gem 'pg', group: :production
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'twitter'
gem 'test-unit'

gem 'hirb'         # モデルの出力結果を表形式で表示するGem
gem 'hirb-unicode' # 日本語などマルチバイト文字の出力時の出力結果のずれに対応

gem 'pry-rails'  # rails console(もしくは、rails c)でirbの代わりにpryを使われる
gem 'pry-doc'    # methodを表示
gem 'pry-byebug' # デバッグを実施

gem 'open_uri_redirections'
gem 'slack-api'
gem 'google-analytics-rails'

gem 'exception_notification', github: 'smartinez87/exception_notification'
gem 'slack-notifier'

# ExecJS::ProgramError TypeErrorの対応
gem 'coffee-script-source', '1.8.0'

group :development, :test do
  gem 'ruby-debug-ide'
  gem 'debase'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'factory_girl_rails', '~> 4.4.1'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rubocop', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
