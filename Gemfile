source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'
gem 'omniauth'
gem 'omniauth-twitter'

# Component requirements
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'erubis', '~> 2.7.0'
gem 'dm-mysql-adapter'
gem 'dm-validations'
gem 'dm-timestamps'
gem 'dm-migrations'
gem 'dm-constraints'
gem 'dm-aggregates'
gem 'dm-types'
gem 'dm-core'
gem 'dm-ar-finders'
gem 'tilt', '1.3.7'
gem 'dropbox-sdk', :require => 'dropbox_sdk'

# Padrino Stable Gem
gem 'padrino', '0.11.1'

group :production do
	gem 'pg'
	gem 'dm-postgres-adapter'
end

group :development, :test do
	gem 'foreman'
end

group :development do
	gem 'debugger'
end

group :test do
	# Guard gem eases running spec automatically
	gem 'guard'
	gem 'guard-rspec'

	gem 'dm-sqlite-adapter'
	gem 'rspec'
	gem 'capybara'
	gem 'selenium-webdriver'
	gem 'cucumber'
	gem 'rack-test', :require => 'rack/test'
end

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.11.1'
# end
