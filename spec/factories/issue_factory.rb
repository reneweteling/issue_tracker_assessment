# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    sequence(:name) { |n| "Issue nr #{n}" }
    description 'Some random text'
    status :pending
  end
end
