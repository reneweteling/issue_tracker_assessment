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
formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
]
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new formatters
SimpleCov.start 'rails'

# run rubocop
rubocop_output = `bundle exec rubocop --color`
puts rubocop_output
rubocop_failed = rubocop_output.include? '[32mno offenses[0m detected'
fail "RuboCop Errors" unless rubocop_failed

RSpec.configure do |config|
  # Config
  config.include FactoryBot::Syntax::Methods
  config.mock_with :rspec
  config.color = true
  config.formatter = :documentation
  config.shared_context_metadata_behavior = :apply_to_host_groups
  # config.order = 'random'

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

RSpec.shared_context 'issues' do
  let(:user){ create :user }
  let(:user_headers){ { Authorization: "Bearer #{login(user)}" } }
  let(:user_issue){ create :issue, assignee: user }

  let(:manager){ create :user, role: :manager }
  let(:manager_headers){ { Authorization: "Bearer #{login(manager)}" } }
  let(:manager_issue){ create :issue, manager: manager, assignee: manager }

  let(:manager2){ create :user, role: :manager }
  let(:manager2_headers){ { Authorization: "Bearer #{login(manager2)}" } }
  let(:manager2_issue){ create :issue, manager: manager2, assignee: manager2 }

  let(:issue){ create :issue }

  def json
    JSON.parse(response.body)
  end

  def login(user)
    auth = {
      auth: {
        email: user.email,
        password: 'test123'
      }
    }

    post '/api/v1/user_token', params: auth, as: :json
    expect(response.status).to eq(201)
    JSON.parse(response.body)['jwt']
  end
end
