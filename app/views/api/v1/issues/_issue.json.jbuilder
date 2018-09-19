# frozen_string_literal: true

json.id issue.id
json.name issue.name
json.description issue.description
json.status issue.status
json.manager do
  json.partial!('user', user: issue.manager) if issue.manager
end
json.assignee do
  json.partial!('user', user: issue.assignee) if issue.assignee
end
json.created_at issue.created_at
json.updated_at issue.updated_at
