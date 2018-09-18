# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :issues
        post 'user_token', to: 'user_token#create'
      end
    end
  end
end
