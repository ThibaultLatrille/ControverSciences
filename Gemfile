source 'https://rubygems.org'

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.7'

gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'faraday-retry'


# Internationalization
gem 'i18n'
gem 'rails-i18n'

# Execute js
gem 'mini_racer'
gem 'execjs'

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Pagination and infinit scrolling
gem 'kaminari'

## Assets compilation and processing
# Use SCSS for stylesheets
gem 'coffee-script'
# Use SCSS for stylesheets
gem 'sass-rails'

# Autoprefixer for Ruby and Ruby on Rails
gem 'autoprefixer-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Produce JSON output
gem 'rabl'
gem 'oj'

gem 'sdoc', group: :doc

# Bib parser to seed the references
gem 'bibtex-ruby'

# Connect to an API from an external domain
gem 'serrano'

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

# Email validation
gem 'email_validator'

# Image upload, resize and storing
gem 'mini_magick'
gem 'fog-aws', require: false # or require: 'fog/aws'

# avoid having carrierwave loading during bundler
# setup.  We need to get ./lib in the load_path first.
gem 'carrierwave'

# Truncate HTML and close tags
gem 'truncate_html'

# Generate and bing sitemap
gem 'sitemap_generator'

# Intercept and send exception to a third service
gem 'exception_notification'
gem 'slack-notifier'

# Use 'ap User.last' for example for awesome print
gem 'awesome_print', require: 'ap'

# Friendly id for SEO
gem 'friendly_id'

# Slack Api wrapper
gem 'slack-ruby-client'

gem 'rails-latex'

gem 'lograge'

group :test do
  gem 'minitest-reporters'
  gem 'mini_backtrace'
  gem 'guard-minitest'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

group :development do
  gem 'web-console'
  gem 'webrick'
  gem 'listen'

  gem 'faker'
  gem 'spring'
  # Model and controller UML class diagram generator, run: 'rake diagram:all'
  gem 'railroady'

  # Reek is a tool that examines Ruby classes, modules and methods and reports any Code Smells it finds.
  gem 'reek'

  # Seek and alert for N+1 queries
  gem 'bullet'

  # Better error page for Rack apps
  gem 'better_errors'
  gem 'binding_of_caller'

  # Support from chrome extension RailsPanel (https://github.com/dejan/rails_panel)
  gem 'meta_request'

  # Internationalizer
  gem 'i15r'
  gem 'missing_t'

  gem 'pry-rails'
end