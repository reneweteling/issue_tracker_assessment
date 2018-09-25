# frozen_string_literal: true

module Api
  module V1
    class IssuesController < BaseController
      before_action :set_issue, only: %i[update destroy]

      def index
        @issues = issues.order(created_at: :desc)
                        .page(page_no)
                        .where(status: status_filters)
      end

      def create
        create_param = params_for_issue
        create_param[:assignee_id] = current_user.id if current_user.user?
        create_param[:manager_id] = current_user.id if current_user.manager?
        @issue = Issue.create!(create_param)
      end

      def update
        @issue.update!(params_for_issue)
      end

      def destroy
        @issue.destroy!
      end

      private

      def status_filters
        params[:status]&.split(',') || Issue.statuses.keys
      end

      def set_issue
        @issue = issues.find(params[:id])
      end

      def issues
        Issue.accessible_by(current_ability)
      end

      def params_for_issue
        attributes = params.require(:issue)
                           .permit %i[
                             name description manager_id
                             assignee_id status
                           ]

        %i[manager_id assignee_id status].each do |field|
          next unless attributes[field].present? && (
              cannot?("update_#{field}".to_sym, @issue) ||
              (
                can?("update_#{field}".to_sym, @issue) &&
                field == :manager_id &&
                (
                  @issue.manager.present? &&
                  @issue.manager_id != attributes[:manager_id]
                ) || (
                  @issue.manager.nil? &&
                  attributes[:manager_id] != current_user.id
                )
              )
            )
          raise CanCan::AccessDenied, "You are not authorised to update #{field}"
        end

        attributes
      end

      def page_no
        params[:page] || 0
      end
    end
  end
end
