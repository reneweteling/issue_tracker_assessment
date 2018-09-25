# frozen_string_literal: true

require 'spec_helper'

describe 'Issue management', type: :request do
  include_context 'issues'

  context 'Manager' do
    it 'lists all my issues' do
      manager_issue.update(name: 'Manager issue')
      user_issue.update(name: 'My issue')
      get '/api/v1/issues', headers: manager_headers
      expect(response.status).to eq(200)
      expect(response.body).to include('My issue')
      expect(response.body).to include('Manager issue')
    end

    it 'assign an issue to myself that is not assigned' do
      put "/api/v1/issues/#{issue.id}", params: {
        issue: {
          manager_id: manager.id
        }
      },
                                        as: :json,
                                        headers: manager_headers

      expect(response.status).to eq(200)
      expect(json['manager']['id']).to eq(manager.id)
    end

    it 'does not unassign an issue with an in_progres status' do
      manager_issue.update(assignee: user, status: :in_progress)
      put "/api/v1/issues/#{manager_issue.id}", params: {
        issue: {
          assignee_id: nil
        }
      },
                                                as: :json,
                                                headers: manager_headers

      expect(response.status).to eq(422)
      expect(response.body).to include('Assignee can\'t be blank')
    end
    it 'unassign an issue that is assigned to me' do
      p = {
        issue: {
          manager_id: nil
        }
      }
      put "/api/v1/issues/#{manager_issue.id}", params: p,
                                                as: :json,
                                                headers: manager_headers

      expect(response.status).to eq(200)
      expect(json['manager']).to eq(nil)
    end

    it 'Can\'t unassign an issue that is assigned to an other' do
      p = {
        issue: {
          manager_id: nil
        }
      }
      put "/api/v1/issues/#{manager2_issue.id}", params: p,
                                                 as: :json,
                                                 headers: manager_headers

      expect(response.status).to eq(200)
      expect(json['manager']).to eq(nil)
    end

    it 'Can\'t assign an issue to someone else' do
      p = {
        issue: {
          manager_id: manager2.id
        }
      }
      put "/api/v1/issues/#{issue.id}", params: p,
                                        as: :json,
                                        headers: manager_headers

      expect(response.status).to eq(422)
    end

    it 'Can\'t assign an issue that is already assigned' do
      p = {
        issue: {
          manager_id: manager.id
        }
      }
      put "/api/v1/issues/#{manager2_issue.id}", params: p,
                                                 as: :json,
                                                 headers: manager_headers

      expect(response.status).to eq(422)
    end

    it 'Can\'t update the status if its not assigned to me' do
      p = {
        issue: {
          status: :resolved
        }
      }
      put "/api/v1/issues/#{manager2_issue.id}", params: p,
                                                 as: :json,
                                                 headers: manager_headers

      expect(response.status).to eq(422)
    end

    it 'Update the status if its assigned to me' do
      p = {
        issue: {
          status: :resolved
        }
      }
      put "/api/v1/issues/#{manager_issue.id}", params: p,
                                                as: :json,
                                                headers: manager_headers

      expect(response.status).to eq(200)
      expect(json['status']).to eq('resolved')
    end
  end
end
