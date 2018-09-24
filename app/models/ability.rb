# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.manager?
      can :read, :all
      can :update_status, Issue, manager_id: user.id
      can :update_manager_id, Issue do |issue|
        issue.manager.nil? || issue.manager == user
      end
    else
      can %i[create read destroy update], Issue, assignee_id: user.id
      cannot :update_manager_id, Issue
      cannot :update_assignee_id, Issue
      cannot :update_status, Issue
    end
  end
end
