# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("Production mode!") if Rails.env.production?
require 'database_cleaner'
require 'rspec/rails'
require 'simplecov'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Simplecov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
]
SimpleCov.start 'rails'

# run rubocop
rubocop_output = `bundle exec rubocop --color`
puts rubocop_output
rubocop_failed = rubocop_output.include? '[32mno offenses[0m detected'
fail "RuboCop Errors" unless rubocop_failed

RSpec.configure do |config|
  # Config
  config.mock_with :rspec
  config.color = true
  config.order = 'random'

  # Ensure Suite is set to use transactions for speed.
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  # Before each spec check if it is a Javascript test and switch between using
  # database transactions or not where necessary.
  config.before :each do
    spec_type = RSpec.current_example.metadata[:js]
    DatabaseCleaner.strategy = spec_type ? :truncation : :transaction
    DatabaseCleaner.start
  end

  # After each spec clean the database.
  config.after :each do
    DatabaseCleaner.clean
  end
end
