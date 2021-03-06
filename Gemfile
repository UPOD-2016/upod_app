source 'https://rubygems.org'
ruby '2.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.3.18'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Elastic search GEMS <<_>>.:.
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'searchkick'
gem 'gemoji-parser'
gem 'devise'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
group :assets do
  gem 'coffee-rails'
end
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'active_record-acts_as'
gem 'acts_as_list'

gem 'bootstrap-sass'
gem 'goldiloader'
# Required for sir trevor
source 'https://rails-assets.org' do
  gem 'rails-assets-underscore'
end

gem 'js-routes'
gem 'mina'
#Use Administrate for admin panel
gem 'administrate', '~> 0.2.2'
gem 'administrate-field-image'
gem 'bourbon'
gem 'friendly_id', '~> 5.1.0'
gem 'carrierwave'
gem 'mini_magick'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Gives pages load times to spot bottle necks
  #gem 'rack-mini-profiler'
  gem 'annotate'
  #Use YARD for documentation generation
  gem 'yard'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
  gem 'railroady'

  # Brakeman scans for known vulnurabilities
  gem 'brakeman'
  gem 'quiet_assets'
  # Make sure there is no unused gems
  gem 'bundler-audit'

  # Make sure style conforms
  gem 'rubocop'

  # Check for unused routes
  gem 'traceroute'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'faker'
end
