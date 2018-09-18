# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    role :user
    sequence(:name) { |n| "Test user #{n}" }
    sequence(:email) { |n| "user-#{n}@dm.com" }
    password 'test123'
    password_confirmation 'test123'
    trait(:admin) {
      role :admin
    }
  end
end
