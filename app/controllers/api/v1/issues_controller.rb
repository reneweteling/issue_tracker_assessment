# frozen_string_literal: true

module Api
  module V1
    class IssuesController < BaseController
      before_action :set_issue, only: %i[update destroy]

      def index
        @issues = issues.order(:created_at).page(page_no)
      end

      def create
        @issue = Issue.create!(params_for_issue)
      end

      def update
        @issue.update!(params_for_issue)
      end

      def destroy
        @issue.destroy!
      end

      private

      def set_issue
        @issue = issues.find(params[:id])
      end

      def issues
        Issue.accessible_by(current_ability)
      end

      def params_for_issue
        attributes = %i[name description]
        attributes << :manager_id if can? :assign_manager, Issue
        attributes << :assignee_id if can? :assign_assignee, Issue
        attributes << :status if can? :update_status, Issue

        params.require(:issue).permit(attributes)
      end

      def page_no
        params[:page] || 0
      end
    end
  end
end
