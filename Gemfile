source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',        '4.1.6'

# Use ActiveModel has_secure_password
gem 'bcrypt',               '3.1.7'

# Pagination and infinit scrolling
gem 'kaminari'

# Use SCSS for stylesheets
gem 'sass-rails',   '4.0.3'
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Produce JSON output
gem 'rabl'
gem 'oj'

gem 'sdoc',         '0.4.0', group: :doc

# Database seeding with fake data
gem 'faker',                '1.4.2'

# Bib parser to seed the references
gem 'bibtex-ruby'

# Connect to an API from an external domain
gem 'faraday'
gem 'faraday_middleware'
gem 'json'

# Markdown processing
gem 'redcarpet'

# Bulk insert
gem 'activerecord-import'

# Postgresql
gem 'pg'

# Image upload, resize and storing
gem 'carrierwave',             '0.10.0'
gem 'mini_magick',             '3.8.0'
gem 'fog',                     '1.23.0'

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :development do
  gem 'spring',  '1.1.3'
end

group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'unicorn',        '4.8.3'
end