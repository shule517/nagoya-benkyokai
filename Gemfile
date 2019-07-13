source 'https://rubygems.org'
ruby "2.6.0" # for heroku

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'sqlite3', group: :development
gem 'pg', group: :production
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'twitter'
gem 'test-unit'

gem 'hirb'         # モデルの出力結果を表形式で表示するGem
# gem 'hirb-unicode' # 日本語などマルチバイト文字の出力時の出力結果のずれに対応

gem 'pry-rails'  # rails console(もしくは、rails c)でirbの代わりにpryを使われる
gem 'pry-doc'    # methodを表示
gem 'pry-byebug' # デバッグを実施
gem 'ruby-debug-ide'

gem 'openssl'
gem 'json'
gem 'open_uri_redirections'
gem 'slack-api'
gem 'google-analytics-rails'

gem 'exception_notification', github: 'smartinez87/exception_notification'
gem 'slack-notifier'
gem 'hashie'
gem 'rspec'
gem 'newrelic_rpm'
gem "autoprefixer-rails" # 自動的にベンダープレフィックスを追加してくれる

gem 'coffee-script-source', '1.8.0' # ExecJS::ProgramError TypeErrorの対応
gem 'active_model_serializers'

# api
gem 'grape'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-entity'
gem 'api-pagination'
gem 'ruby-swagger'
gem 'kaminari'
gem 'will_paginate'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rubocop', '>= 0.49.0'

  gem 'debase'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rails-controller-testing'
  gem 'webmock'
  gem 'vcr'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'annotate'
end

group :development do
  gem 'web-console'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'foreman'
  gem "rails_real_favicon" # favicon生成用
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
