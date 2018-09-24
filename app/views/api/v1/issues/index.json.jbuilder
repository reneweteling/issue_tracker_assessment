# frozen_string_literal: true

json.meta do
  json.count @issues.total_count
  json.page @issues.current_page
end
json.items do
  json.array! @issues, partial: 'issue', as: :issue
end
