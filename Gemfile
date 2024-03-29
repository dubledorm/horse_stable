source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0.rc1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false


group :test do
  gem 'database_cleaner'
  gem "factory_girl_rails" , '~> 1.7.0'
  gem "test-unit"
  gem "mocha", :require => false
  gem 'capybara', '~> 2.18'
  gem "launchy"
  gem "autotest"
  gem "autotest-rails-pure"
  gem "autotest-notification"
  gem 'webmock'
  gem 'ruby-prof'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end


group :development, :test do
  # Call 'bye_bug.rb' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails', '~> 4.0.0.rc1'
  gem 'rails-controller-testing'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
# Call 'bye_bug.rb' anywhere in the code to stop execution and get a debugger console

  gem 'shoulda', '~> 3.5.0'
  gem 'shoulda-matchers'
  gem 'shoulda-context'
  gem 'selenium-webdriver'
  gem 'rack_session_access'
  gem 'timecop'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  #  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop'
  gem 'rubocop-rails'
end

gem 'activeadmin'
gem 'activeadmin_blaze_theme'

gem 'haml'
gem 'devise'
gem 'cancancan'
gem 'rolify'
gem 'draper'
gem 'has_scope'
gem 'whenever', require: false
gem 'awesome_print'
gem 'uuidtools' # Для генерации GUIDов

# Обработка изображения для active_storage
gem 'image_processing', '~> 1.2'

# Авторизация через сторонние системы
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-vkontakte'

# Поиск elastic-search
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'react-rails'

gem 'kaminari'
gem 'breadcrumbs_on_rails'

gem 'dotenv-rails'
