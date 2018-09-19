# frozen_string_literal: true

module Api
  module V1
    class BaseController < ::ApplicationController
      include Knock::Authenticable
      before_action :authenticate_user

      rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_error
      rescue_from CanCan::AccessDenied, with: :record_invalid_error

      def not_found_error
        head :not_found
      end

      def record_invalid_error(error)
        render json: { errors: error.message }, status: :unprocessable_entity
      end
    end
  end
end
