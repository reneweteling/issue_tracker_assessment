# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.manager?

    if user.user?
      can %i[create read destroy update], Issue, assignee_id: user.id
      cannot :assign_manager, Issue
      cannot :assign_assignee, Issue
      cannot :update_status, Issue
    end
  end
end
