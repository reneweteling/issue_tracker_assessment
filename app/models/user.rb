# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  enum role: { user: 'user', manager: 'manager' }
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id'
  has_many :managing_issues, class_name: 'Issue', foreign_key: 'manager_id'
end
