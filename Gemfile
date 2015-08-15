source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',        '4.1.6'

# Execute js
gem 'therubyracer'
gem 'execjs'

# Use ActiveModel has_secure_password
gem 'bcrypt',               '3.1.7'

# Pagination and infinit scrolling
gem 'kaminari'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Produce JSON output
gem 'rabl'
gem 'oj'

gem 'sdoc',         '0.4.0', group: :doc

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

# Send transactional mail using MailGun
gem 'mailgun-ruby', require: 'mailgun'

# Postgresql
gem 'pg'

# Use octokit for GitHub API
gem 'octokit'

# Get info about the client browser
gem 'browser'

# Search toolbox for postgresql
gem 'pg_search'

# Image upload, resize and storing
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'

# Truncate HTML and close tags
gem 'truncate_html'

# Generate and bing sitemap
gem 'sitemap_generator'

# Intercept and send exception to a third service
gem 'exception_notification'
gem 'slack-notifier'

# Friendly id for SEO
gem 'friendly_id', '~> 5.0.0'

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :development do
  # Database seeding with fake data
  gem 'faker',                '1.4.2'
  gem 'spring',  '1.1.3'
  gem 'quiet_assets'
end

group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'unicorn',        '4.8.3'
end
