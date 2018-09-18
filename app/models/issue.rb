# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :manager, class_name: 'User', required: false
  belongs_to :assignee, class_name: 'User', required: false

  enum status: {
    pending: 'pending', in_progress: 'in_progress', resolved: 'resolved'
  }
end
